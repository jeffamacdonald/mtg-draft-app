require 'rails_helper'

RSpec.describe Import::Card do
  describe 'initialization' do
    it 'creates a card with keyword arguments' do
      card = Import::Card.new(count: 2, set: 'M21', name: 'Lightning Bolt')

      expect(card.count).to eq(2)
      expect(card.set).to eq('M21')
      expect(card.name).to eq('Lightning Bolt')
    end
  end
end
