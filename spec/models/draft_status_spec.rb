require 'rails_helper'

RSpec.describe DraftStatus do
  describe '.all' do
    it 'returns all status options' do
      expect(described_class.all).to eq(['pending', 'active', 'completed'])
    end
  end

  describe '.pending' do
    it 'returns pending status' do
      expect(described_class.pending).to eq('pending')
    end
  end

  describe '.active' do
    it 'returns active status' do
      expect(described_class.active).to eq('active')
    end
  end

  describe '.completed' do
    it 'returns completed status' do
      expect(described_class.completed).to eq('completed')
    end
  end
end
