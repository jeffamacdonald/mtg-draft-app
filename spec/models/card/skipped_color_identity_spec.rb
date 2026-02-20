require 'rails_helper'

RSpec.describe Card::SkippedColorIdentity do
  describe '#background_class' do
    it 'returns bg-danger class' do
      skipped_color_identity = Card::SkippedColorIdentity.new
      expect(skipped_color_identity.background_class).to eq('bg-danger')
    end
  end

  describe '#text_class' do
    it 'returns nil' do
      skipped_color_identity = Card::SkippedColorIdentity.new
      expect(skipped_color_identity.text_class).to be_nil
    end
  end
end
