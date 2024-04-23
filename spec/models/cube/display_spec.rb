require 'rails_helper'

RSpec.describe Cube::Display do
  describe '#sections' do
    let(:cube) { create(:cube) }
    let(:display) { Cube::Display.new(cube.cube_cards) }
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
end
