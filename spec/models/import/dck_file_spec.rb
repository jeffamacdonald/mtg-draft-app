require 'rails_helper'

RSpec.describe Import::DckFile do
  describe "#import" do
    let(:cube) { create :cube }
    let(:bolt) { Import::Card.new(count: 1, name: "Lightning Bolt", set: "LEB") }
    let(:bob) { Import::Card.new(count: 1, name: "Dark Confidant", set: "RAV") }
    let(:import_cards) { [bolt, bob] }
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

    subject { described_class.new(import_cards, cube).import }

    context "when some cards are not found" do
      let(:bob) { Import::Card.new(count: 1, name: "Bob", set: "RAV") }
      let(:scryfall_response) do
        {
          "not_found": [{
            "name": "Bob",
            "set": "RAV"
          }],
          "data": [bolt_card_hash]
        }
      end

      it "creates no new cards and returns false" do
        expect {
          expect(subject).to eq false
        }.to not_change { Card.count }
          .and not_change { CubeCard.count }
      end
    end

    context "when no cards yet exist" do
      it "creates card records, cube card records, and returns true" do
        expect {
          expect(subject).to eq true
        }.to change { Card.count }.by(2)
          .and change { CubeCard.count }.by(2)
        bolt_card = Card.find_by(name: "Lightning Bolt")
        bob_card = Card.find_by(name: "Dark Confidant")
        bolt_cube_card = CubeCard.find_by(card: bolt_card)
        bob_cube_card = CubeCard.find_by(card: bob_card)
        expect(bolt_card.cost).to eq "{R}"
        expect(bolt_card.cmc).to eq 1
        expect(bolt_card.card_text).to eq "Deal 3 damage to any target."
        expect(bolt_card.layout).to eq "something"
        expect(bolt_card.power).to eq nil
        expect(bolt_card.toughness).to eq nil
        expect(bolt_card.default_image).to eq "httpblah"
        expect(bolt_card.color_identity.color_identities).to eq ["R"]
        expect(bolt_card.default_set).to eq "LEB"
        expect(bolt_card.type_line).to eq "Instant"
        expect(bob_card.cost).to eq "{1}{B}"
        expect(bob_card.cmc).to eq 2
        expect(bob_card.card_text).to eq "At the beginning of your upkeep, reveal the top card of your library and put that card into your hand. You lose life equal to its converted mana cost."
        expect(bob_card.layout).to eq "normal"
        expect(bob_card.power).to eq 2
        expect(bob_card.toughness).to eq 1
        expect(bob_card.default_image).to eq "httpblahnormal"
        expect(bob_card.color_identity.color_identities).to eq ["B"]
        expect(bob_card.default_set).to eq "RAV"
        expect(bob_card.type_line).to eq "Creature - Human Wizard"
        expect(bob_cube_card.cube).to eq cube
        expect(bob_cube_card.count).to eq 1
        expect(bob_cube_card.custom_cmc).to eq bob_card.cmc
        expect(bob_cube_card.custom_color_identity).to eq bob_card.color_identity.color_identities
        expect(bob_cube_card.custom_image).to eq bob_card.default_image
        expect(bob_cube_card.custom_set).to eq bob_card.default_set
        expect(bolt_cube_card.cube).to eq cube
        expect(bolt_cube_card.count).to eq 1
        expect(bolt_cube_card.custom_cmc).to eq bolt_card.cmc
        expect(bolt_cube_card.custom_color_identity).to eq bolt_card.color_identity.color_identities
        expect(bolt_cube_card.custom_image).to eq bolt_card.default_image
        expect(bolt_cube_card.custom_set).to eq bolt_card.default_set
      end
    end

    context "when cards exist" do
      let!(:bolt_card) do
        create(:card,
          name: "Lightning Bolt",
          default_set: "LEA"
        )
      end
      let!(:bob_card) do
        create(:card,
          name: "Dark Confidant",
          default_set: "MMA"
        )
      end
      let!(:bolt_cube_card) do
        create(:cube_card,
          name: "Lightning Bolt",
          custom_set: "LEA",
          card: bolt_card
        )
      end
      let!(:bob_cube_card) do
        create(:cube_card,
          name: "Dark Confidant",
          custom_set: "MMA",
          card: bob_card
        )
      end

      context "when matching card exists but no matching cube card exists" do
        it "does NOT create card record, creates cube card record from scryfall data, and returns true" do
          expect {
            expect(subject).to eq true
          }.to not_change { Card.count }
            .and change { CubeCard.count }.by(2)
          expect(scryfall_stub).to have_been_requested
        end
      end

      context "when matching cube cards exist" do
        let!(:bolt_card) do
          create(:card,
            name: "Lightning Bolt",
            default_set: "LEA"
          )
        end
        let!(:bob_card) do
          create(:card,
            name: "Dark Confidant",
            default_set: "MMA"
          )
        end
        let!(:bolt_cube_card) do
          create(:cube_card,
            name: "Lightning Bolt",
            custom_set: "LEB",
            custom_image: "custom_img",
            card: bolt_card
          )
        end
        let!(:bob_cube_card) do
          create(:cube_card,
            name: "Dark Confidant",
            custom_set: "RAV",
            custom_image: "custom_img",
            card: bob_card
          )
        end

        it "does NOT create card record, creates cube card record from cube card data, and returns true" do
          expect {
            expect(subject).to eq true
          }.to not_change { Card.count }
            .and change { CubeCard.count }.by(2)
          expect(scryfall_stub).not_to have_been_requested
        end
      end
    end
  end
end
