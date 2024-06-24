require 'rails_helper'

RSpec.describe Card do
  describe "#color_identity" do
    let(:card) { create(:card) }

    it "returns a ColorIdentity object" do
      expect(card.color_identity.class).to eq Card::ColorIdentity
    end
  end
end
