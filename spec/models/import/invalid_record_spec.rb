require 'rails_helper'

RSpec.describe Import::InvalidRecord do
  describe 'initialization' do
    it 'creates an invalid record with name and error message' do
      invalid_record = Import::InvalidRecord.new('Lightning Bolt', 'Card not found in database')

      expect(invalid_record.name).to eq('Lightning Bolt')
      expect(invalid_record.error_message).to eq('Card not found in database')
    end
  end
end
