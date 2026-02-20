require 'rails_helper'

RSpec.describe SkippedPick do
  describe '#name' do
    it 'returns SKIPPED' do
      skipped_pick = SkippedPick.new
      expect(skipped_pick.name).to eq('SKIPPED')
    end
  end

  describe '#color_identity' do
    it 'returns a Card::SkippedColorIdentity instance' do
      skipped_pick = SkippedPick.new
      expect(skipped_pick.color_identity).to be_a(Card::SkippedColorIdentity)
    end
  end
end
