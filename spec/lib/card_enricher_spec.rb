require 'rails_helper'

RSpec.describe CardEnricher do
  describe '.get_enriched_card' do
    let(:card) do
      {
        "name": "Shock",
        "set": set,
        "count": 1,
        "custom_color_identity": ["R"]
      }
    end
    let(:set) { "SHD" }
    let(:set_param) { "&set=#{set}" }
    let(:scryfall_response) do
      {
        "name": "shock",
        "layout": "something",
        "cmc": 1,
        "set": set,
        "image_uris": {
          "normal": "image"
        }
      }
    end
    let(:status) { 200 }
    let(:expected_response) do
      Clients::ScryfallCard.new(
        name: "shock",
        layout: "something",
        cmc: 1,
        image_uri: "image",
        color_identity: ["R"],
        set: "SHD",
        count: 1
      )
    end
    let!(:scryfall_stub) do
      stub_request(:get, "#{Clients::Scryfall::BASE_URL}/cards/named?exact=Shock" + set_param)
        .to_return(status: status, body: scryfall_response.to_json, headers: {})
    end

    subject { described_class.get_enriched_card(card) }

    context 'when scryfall finds card' do
      it 'returns card hash with merged scryfall data' do
        expect(subject).to eq expected_response
      end
    end

    context 'when scryfall cannot find card' do
      let(:status) { 404 }
      let(:expected_response) do
        {
          :error => {
            :name => "Shock",
            :set => set,
            :message => "Card Not Found in Set"
          }
        }
      end

      it 'returns error' do
        expect(subject).to eq expected_response
      end

      context 'when set is nil' do
        let(:set) { nil }
        let(:set_param) { "" }
        let(:expected_response) do
          {
            :error => {
              :name => "Shock",
              :message => "Card Not Found"
            }
          }
        end

        it 'returns error' do
          expect(subject).to eq expected_response
        end
      end
    end
  end
end
