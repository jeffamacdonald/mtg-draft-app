require "rails_helper"

RSpec.describe CardSanitizer do
  describe ".call" do
    subject { described_class.call(card_data, import_card) }

    context "when card is default" do
      let(:name) { "Lightning Bolt" }
      let(:layout) { "normal" }
      let(:mana_cost) { "{R}" }
      let(:cmc) { 1 }
      let(:type_line) { "Instant" }
      let(:oracle_text) { "Deal 3 damage to any target." }
      let(:color_identity) { ["R"] }
      let(:set) { "LEB" }
      let(:image_uri) { "normal_image.png" }
      let(:import_card) do
        Import::Card.new(
          count: 1,
          name: name,
          set: set
        )
      end
      let(:card_data) do
        {
          :name => name,
          :layout => layout,
          :mana_cost => mana_cost,
          :cmc => cmc,
          :type_line => type_line,
          :oracle_text => oracle_text,
          :color_identity => color_identity,
          :set => set,
          :image_uris => {
            :normal => image_uri
          }
        }
      end
      let(:expected_response) do
        Clients::ScryfallCard.new(
          count: import_card.count,
          name: name,
          layout: layout,
          image_uri: image_uri,
          mana_cost: mana_cost,
          cmc: cmc,
          type_line: type_line,
          oracle_text: oracle_text,
          color_identity: color_identity,
          set: set
        )
      end

      it "returns expected_response" do
        expect(subject).to eq expected_response
      end
    end

    context "when card is split" do
      let(:name) { "Fire // Ice" }
      let(:layout) { "split" }
      let(:cmc) { 2 }
      let(:mana_cost) { "{1}{R} // {1}{U}" }
      let(:type_line) { "Instant // Instant" }
      let(:oracle_text_1) { "Fire deals 2 damage divided as you choose among one or two targets." }
      let(:oracle_text_2) { "Tap target permanent.\nDraw a card." }
      let(:color_identity) { ["R", "U"] }
      let(:set) { "DMR" }
      let(:image_uri) { "normal_image.png" }
      let(:import_card) do
        Import::Card.new(
          count: 1,
          name: name,
          set: set
        )
      end
      let(:card_data) do
        {
          :name => name,
          :layout => layout,
          :mana_cost => mana_cost,
          :type_line => type_line,
          :color_identity => color_identity,
          :set => set,
          :image_uris => {
            :normal => image_uri
          },
          :card_faces => [{
            :name => "Fire",
            :mana_cost => "{1}{R}",
            :oracle_text => oracle_text_1
          }, {
            :name => "Ice",
            :mana_cost => "{1}{U}",
            :oracle_text => oracle_text_2
          }]
        }
      end
      let(:expected_response) do
        Clients::ScryfallCard.new(
          count: import_card.count,
          name: name,
          layout: layout,
          image_uri: image_uri,
          mana_cost: mana_cost,
          cmc: cmc,
          type_line: type_line,
          oracle_text: "#{oracle_text_1}\n#{oracle_text_2}",
          color_identity: color_identity,
          set: set
        )
      end

      it "returns expected_response" do
        expect(subject).to eq expected_response
      end
    end

    context "when card is transform" do
      let(:name) { "Westvale Abbey" }
      let(:layout) { "transform" }
      let(:cmc) { 0 }
      let(:mana_cost) { "" }
      let(:type_line) { "Legendary Land" }
      let(:oracle_text_1) { "Tap add mana make dudes sac dudes" }
      let(:oracle_text_2) { "flying trample lifelink haste" }
      let(:color_identity) { [] }
      let(:set) { "SOI" }
      let(:image_uri) { "normal_image.png" }
      let(:import_card) do
        Import::Card.new(
          count: 1,
          name: name,
          set: set
        )
      end
      let(:card_data) do
        {
          :name => name + " // Ormendahl, Profane Prince",
          :layout => layout,
          :set => set,
          :card_faces => [{
            :name => name,
            :oracle_text => oracle_text_1,
            :mana_cost => "",
            :colors => color_identity,
            :type_line => type_line,
            :image_uris => {
              :normal => image_uri
            }
          }, {
            :name => "Ormendahl, Profane Prince",
            :oracle_text => oracle_text_2,
            :mana_cost => "",
            :colors => ["B"],
            :type_line => "Legendary Creature",
            :image_uris => {
              :normal => "normal_back_image.png"
            }
          }]
        }
      end
      let(:expected_response) do
        Clients::ScryfallCard.new(
          count: import_card.count,
          name: name,
          layout: layout,
          image_uri: image_uri,
          mana_cost: mana_cost,
          cmc: cmc,
          type_line: type_line,
          oracle_text: "#{oracle_text_1}\n#{oracle_text_2}",
          color_identity: color_identity,
          set: set
        )
      end

      it "returns expected_response" do
        expect(subject).to eq expected_response
      end
    end

    context "when card is adventure" do
      let(:name) { "Brazen Borrower" }
      let(:layout) { "adventure" }
      let(:cmc) { 2 }
      let(:mana_cost) { "{1}{U}{U} // {1}{U}" }
      let(:type_line) { "Creature — Faerie Rogue // Instant — Adventure" }
      let(:oracle_text_1) { "flying flash" }
      let(:oracle_text_2) { "bounce something" }
      let(:color_identity) { ["U"] }
      let(:set) { "ELD" }
      let(:image_uri) { "normal_image.png" }
      let(:import_card) do
        Import::Card.new(
          count: 1,
          name: name,
          set: set
        )
      end
      let(:card_data) do
        {
          :name => name + " // Petty Theft",
          :layout => layout,
          :image_uris => {
            :normal => image_uri
          },
          :mana_cost => mana_cost,
          :type_line => type_line,
          :color_identity => color_identity,
          :set => set,
          :card_faces => [{
            :name => name,
            :mana_cost => "{1}{U}{U}",
            :oracle_text => oracle_text_1
          }, {
            :name => "Petty Theft",
            :mana_cost => "{1}{U}",
            :oracle_text => oracle_text_2
          }]
        }
      end
      let(:expected_response) do
        Clients::ScryfallCard.new(
          count: import_card.count,
          name: name,
          layout: layout,
          image_uri: image_uri,
          mana_cost: mana_cost,
          cmc: cmc,
          type_line: type_line,
          oracle_text: "#{oracle_text_1}\n#{oracle_text_2}",
          color_identity: color_identity,
          set: set
        )
      end

      it "returns expected_response" do
        expect(subject).to eq expected_response
      end
    end

    context "when card is flip" do
      let(:name) { "Erayo, Soratami Ascendant" }
      let(:layout) { "flip" }
      let(:cmc) { 2 }
      let(:mana_cost) { "{1}{U}" }
      let(:type_line) { "Creature - Wizard // Legendary Enchantment" }
      let(:oracle_text_1) { "flying" }
      let(:oracle_text_2) { "counter stuff" }
      let(:color_identity) { ["U"] }
      let(:set) { "SOK" }
      let(:image_uri) { "normal_image.png" }
      let(:power) { 1 }
      let(:toughness) { 1 }
      let(:import_card) do
        Import::Card.new(
          count: 1,
          name: name,
          set: set
        )
      end
      let(:card_data) do
        {
          :name => name + " // Erayo's Essence",
          :layout => "flip",
          :image_uris => {
            :normal => "normal_image.png"
          },
          :mana_cost => mana_cost,
          :type_line => type_line,
          :color_identity => color_identity,
          :set => set,
          :power => power,
          :toughness => toughness,
          :cmc => cmc,
          :card_faces => [{
            :name => name,
            :oracle_text => oracle_text_1,
            :type_line => "Creature - Wizard"
          }, {
            :name => "Erayo's Essence",
            :oracle_text => oracle_text_2,
            :type_line => "Legendary Enchantment"
          }]
        }
      end
      let(:expected_response) do
        Clients::ScryfallCard.new(
          count: import_card.count,
          name: name,
          layout: layout,
          image_uri: image_uri,
          mana_cost: mana_cost,
          cmc: cmc,
          type_line: type_line,
          oracle_text: "#{oracle_text_1}\n#{oracle_text_2}",
          color_identity: color_identity,
          set: set,
          power: power,
          toughness: toughness
        )
      end

      it "returns expected_response" do
        expect(subject).to eq expected_response
      end
    end
  end
end
