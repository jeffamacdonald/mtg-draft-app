require 'rails_helper'

RSpec.describe Clients::ScryfallCard do
  let(:color_identity) { ["R"] }
  let(:type_line) { "Instant" }
  let(:scryfall_card) do
    described_class.new(
      name: "Lightning Bolt",
      mana_cost: "{R}",
      cmc: 1,
      oracle_text: "Deal 3 damage to any target.",
      layout: "normal",
      image_uri: "https://example.com/image",
      color_identity: color_identity,
      set: "LEB",
      type_line: type_line
    )
  end

  describe "#create_card!" do
    subject { scryfall_card.create_card! }

    it "creates a card" do
      expect {
        subject
      }.to change(Card, :count).by(1)
      expect(Card.first.color_identity.color_identities).to eq color_identity
    end

    context "when type line has Land" do
      let(:type_line) { "Legendary Land" }

      it "card is created with L color identity" do
        expect {
          subject
        }.to change(Card, :count).by(1)
        expect(Card.first.color_identity.color_identities).to eq ["L"]
      end
    end

    context "when color identity is empty" do
      let(:color_identity) { [] }

      it "card is created with C color identity" do
        expect {
          subject
        }.to change(Card, :count).by(1)
        expect(Card.first.color_identity.color_identities).to eq ["C"]
      end
    end
  end
end
