require 'rails_helper'

RSpec.describe Cube::Display do
  describe '#sections' do
    let(:cube) { create(:cube) }
    let(:display) { Cube::Display.new(cube.cube_cards.joins(:card).select("cube_cards.*", "cards.name", "cards.type_line", "cards.card_text").order("cards.name")) }
    let!(:white_card) { create :cube_card, color_identity: ["W"], cube: cube }
    let!(:blue_card) { create :cube_card, color_identity: ["U"], cube: cube }
    let!(:black_card) { create :cube_card, color_identity: ["B"], cube: cube }
    let!(:red_card) { create :cube_card, color_identity: ["R"], cube: cube }
    let!(:green_card) { create :cube_card, color_identity: ["G"], cube: cube }
    let!(:colorless_card) { create :cube_card, color_identity: ["C"], cube: cube }
    let!(:land_card) { create :cube_card, color_identity: ["L"], cube: cube }
    let!(:gold_card) { create :cube_card, color_identity: ["U", "R"], cube: cube }
    subject { display.sections }
    
    it 'returns sections with appropriate titles' do
      section_titles = subject.map(&:title)
      expect(section_titles).to match_array(['White', 'Blue', 'Black', 'Red', 'Green', 'Gold', 'Colorless', 'Land'])
    end
    
    it 'returns sections with appropriate cards' do
      expect(subject.find {|section| section.title == "White"}.cards.first).to eq white_card
      expect(subject.find {|section| section.title == "Blue"}.cards.first).to eq blue_card
      expect(subject.find {|section| section.title == "Black"}.cards.first).to eq black_card
      expect(subject.find {|section| section.title == "Red"}.cards.first).to eq red_card
      expect(subject.find {|section| section.title == "Green"}.cards.first).to eq green_card
      expect(subject.find {|section| section.title == "Gold"}.cards.first).to eq gold_card
      expect(subject.find {|section| section.title == "Colorless"}.cards.first).to eq colorless_card
      expect(subject.find {|section| section.title == "Land"}.cards.first).to eq land_card
    end
    
    it 'returns sections with cards sorted within each section' do
      create(:cube_card, color_identity: ["W"], cube: cube)
      cards = subject.find {|section| section.title == "White"}.cards
      sorted_cards = cards.sort_by { |card| card.name }
      expect(cards).to eq(sorted_cards)
    end
  end

  describe 'land section ordering' do
    let(:land_class) { Struct.new(:name, :type_line, :card_text, :color_identity) }
    let(:land_identity) { Card::ColorIdentity.new(["L"]) }

    def land(name, text, type_line: "Land")
      land_class.new(name, type_line, text, land_identity)
    end

    it 'orders lands by type, color pairs, any color, colorless, then single colors in WUBRG order' do
      lands = [
        land("mono green", "{T}: Add {G}."),
        land("mono white", "{T}: Add {W}."),
        land("colorless", "{T}: Add {C}."),
        land("any color", "{T}: Add one mana of any color."),
        land("plains island typed", "Plains Island cycling {2}"),
        land("white blue dual", "{T}: Add {W} or {U}."),
        land("all types", "Enters tapped.", type_line: "Land — Plains Island Swamp Mountain Forest")
      ]

      land_section = Cube::Display.new(lands).sections.find { |section| section.title == "Land" }

      expect(land_section.cards.map(&:name)).to eq(
        ["all types", "white blue dual", "plains island typed", "any color", "colorless", "mono white", "mono green"]
      )
    end

    it 'puts lands with three or more basic land types first, however the type line is worded' do
      lands = [
        land("dual typed", "Enters tapped.", type_line: "Land — Forest Plains"),
        land("creature land", "Enters tapped.", type_line: "Land Creature — Forest Dryad"),
        land("legendary tri-land", "Enters tapped.", type_line: "Legendary Land — Mountain Forest Plains"),
        land("tri-land", "Enters tapped.", type_line: "Land — Island Swamp Mountain")
      ]

      land_section = Cube::Display.new(lands).sections.find { |section| section.title == "Land" }

      expect(land_section.cards.first(2).map(&:name)).to match_array(["legendary tri-land", "tri-land"])
    end

    it 'does not fail on a land with no rules text' do
      sections = Cube::Display.new([land("blank", nil)]).sections

      expect(sections.map(&:title)).to eq(["Land"])
    end
  end
end
