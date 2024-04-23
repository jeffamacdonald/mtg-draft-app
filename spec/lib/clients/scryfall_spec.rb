require 'rails_helper'

RSpec.describe Clients::Scryfall do
  describe '#get_card' do
    let(:card_name) { "Austere Command" }
    let(:scryfall_response) do
      {
        "name": card_name,
        "layout": "normal",
        "image_uris": {
          "small": "httpblah",
          "normal": "httpblah"
        },
        "mana_cost": "{4}{W}{W}",
        "cmc": 6,
        "type_line": "Sorcery",
        "oracle_text": "Choose two —\n• Destroy all artifacts.\n• Destroy all enchantments.\n• Destroy all creatures with converted mana cost 3 or less.\n• Destroy all creatures with converted mana cost 4 or greater.",
        "color_identity": ["W"],
        "set": "LRW"
      }
    end
    let(:status_code) {200}
    let!(:scryfall_stub) do
      stub_request(:get, "#{described_class::BASE_URL}/cards/named?#{scryfall_params}")
        .to_return(status: status_code, body: scryfall_response.to_json, headers: {})
    end
    let(:set) { nil }
    let(:import_card) do
      Import::Card.new(name: card_name, set: set)
    end

    context 'when params contains only name' do
      let(:scryfall_params) { "exact=#{card_name}" }
      let(:encoded_faraday_params) {"/cards/named?exact=Austere+Command"}

      subject { described_class.new.get_card(card_name) }

      it 'calls scryfall with only name' do
        subject
        expect(scryfall_stub).to have_been_requested
      end

      it 'name is encoded' do
        expect_any_instance_of(Faraday::Connection).to receive(:get)
          .with(encoded_faraday_params).and_call_original
        subject
      end

      it 'sanitizes response' do
        expect(CardSanitizer).to receive(:call).with(scryfall_response, import_card)
        subject
      end

      context 'when scryfall returns 404 status' do
        let(:status_code) {404}

        it 'returns nil' do
          expect{subject}.to raise_error Faraday::ResourceNotFound
        end
      end
    end

    context 'when params contain both name and set' do
      let(:set) {'leb'}
      let(:scryfall_params) { "exact=#{card_name}&set=#{set}" }

      subject { described_class.new.get_card(card_name, set) }

      it 'calls scryfall with name and set' do
        subject
        expect(scryfall_stub).to have_been_requested
      end
    end
  end

  describe '#get_card_list' do
    let(:bolt_card_hash) do
      {
        "name": "Lightning Bolt",
        "layout": "something",
        "image_uris": {
          "small": "httpblah",
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
        "not_found": [{
          "name": bad_query_data.name,
          "set": bad_query_data.set
        }],
        "data": [bolt_card_hash, bob_card_hash]
      }
    end
    let!(:scryfall_stub) do
      stub_request(:post, "#{described_class::BASE_URL}/cards/collection").with(body: params)
        .to_return(status: 200, body: scryfall_response.to_json, headers: {})
    end
    let(:bolt) do
      Import::Card.new(
        count: 1,
        name: "Lightning Bolt",
        set: "LEB"
      )
    end
    let(:bob) do
      Import::Card.new(
        count: 1,
        name: "Dark Confidant",
        set: "RAV"
      )
    end
    let(:bad_query_data) do
      Import::Card.new(
        count: 1,
        name: "Some Garbage",
        set: "LEB"
      )
    end
    let(:import_cards) { [bolt, bob, bad_query_data] }
    let(:params) do
      {
        "identifiers": [{
          name: bolt.name,
          set: bolt.set
        }, {
          name: bob.name,
          set: bob.set
        }, {
          name: bad_query_data.name,
          set: bad_query_data.set
        }]
      }
    end
    let(:expected_response) do
      [
        [
          CardSanitizer.call(bolt_card_hash, bolt),
          CardSanitizer.call(bob_card_hash, bob)
        ],
        ["#{bad_query_data.name} was not found."]
      ]
    end

    subject { described_class.new.get_card_list(import_cards) }

    it 'calls scryfall stub with expected params' do
      subject
      expect(scryfall_stub).to have_been_requested
    end

    it 'returns expected response' do
      expect(subject).to match_array(expected_response)
    end
  end
end
