require 'rails_helper'

RSpec.describe CubesController, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:cube) { create(:cube, owner: user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get cubes_path
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:cube) { create(:cube, :with_cube_cards) }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get cube_path(cube)
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get new_cube_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:file) { fixture_file_upload('test_cube.dck', 'text/plain') }
    let(:valid_params) do
      {
        cube: {
          name: 'Test Cube',
          import_file: file
        }
      }
    end
    let(:bolt) { Import::Card.new(count: 1, set: "LEB", name: "Lightning Bolt") }
    let(:bob) { Import::Card.new(count: 1, set: "RAV", name: "Dark Confidant") }
    let(:import_cards) { [bolt, bob] }
    let(:invalid_records) { [] }
    let(:dck_parser) { instance_double(DckParser, call: [import_cards, invalid_records]) }
    let(:bolt_card_hash) do
      {
        "name": "Lightning Bolt",
        "layout": "something",
        "image_uris": {
          "small": "httpsmallblah",
          "normal": "httpblah"
        },
        "mana_cost": "{R}",
        "cmc": 1,
        "type_line": "Instant",
        "oracle_text": "Deal 3 damage to any target.",
        "color_identity": ["R"],
        "set": "LEB"
      }
    end
    let(:bob_card_hash) do
      {
        "name": "Dark Confidant",
        "layout": "normal",
        "image_uris": {
          "small": "httpblahsmall",
          "normal": "httpblahnormal"
        },
        "mana_cost": "{1}{B}",
        "cmc": 2,
        "type_line": "Creature - Human Wizard",
        "oracle_text": "At the beginning of your upkeep, reveal the top card of your library and put that card into your hand. You lose life equal to its converted mana cost.",
        "color_identity": ["B"],
        "power": 2,
        "toughness": 1,
        "set": "RAV"
      }
    end
    let(:scryfall_response) do
      {
        "not_found": [],
        "data": [bolt_card_hash, bob_card_hash]
      }
    end
    let(:expected_scryfall_params) do
      {
        "identifiers": [{
          name: bolt.name,
          set: bolt.set
        }, {
          name: bob.name,
          set: bob.set
        }]
      }
    end
    let!(:scryfall_stub) do
      stub_request(:post, "#{Clients::Scryfall::BASE_URL}/cards/collection").with(body: expected_scryfall_params)
        .to_return(status: 200, body: scryfall_response.to_json, headers: {})
    end

    before do
      allow(DckParser).to receive(:new).and_return(dck_parser)
    end

    before do
      sign_in user
    end

    context 'with valid parameters' do
      it 'creates a new cube and cube cards' do
        expect {
          post cubes_path, params: valid_params
        }.to change { Cube.count }.by(1)
          .and change { Card.count }.by(2)
          .and change { CubeCard.count }.by(2)
      end

      it 'redirects to the cubes index page' do
        post cubes_path, params: valid_params
        expect(response).to redirect_to(cubes_path)
      end
    end

    context 'when dck parser returns errors' do
      let(:invalid_records) { [
          Import::InvalidRecord.new(name: "bad card", error_message: "nope"),
          Import::InvalidRecord.new(name: "another bad card", error_message: "bummer")
        ]
      }
      let(:import_cards) { [] }

      it 'does not create a new cube' do
        expect {
          post cubes_path, params: valid_params
        }.to_not change { Cube.count }
      end

      it 'redirects to new' do
        post cubes_path, params: valid_params
        expect(flash[:error]).to eq "Failed to import cube: bad card: nope, another bad card: bummer"
        expect(response).to redirect_to(new_cube_path)
      end
    end

    context "when importer returns errors" do
      let(:scryfall_response) do
        {
          "not_found": [{
            "name": "Bob",
            "set": "RAV"
          }],
          "data": [bolt_card_hash]
        }
      end

      it 'does not create a new cube' do
        expect {
          post cubes_path, params: valid_params
        }.to_not change { Cube.count }
      end

      it 'redirects to new' do
        post cubes_path, params: valid_params
        expect(flash[:error]).to eq "Bob was not found."
        expect(response).to redirect_to(new_cube_path)
      end
    end
  end
end
