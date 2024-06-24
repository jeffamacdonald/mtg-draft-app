require 'rails_helper'

RSpec.describe CubeCard do
  describe "#color_identity" do
    let(:card) { create(:card) }
    let(:cube_card) { create(:cube_card, card: card) }
    subject { cube_card.color_identity }

    it "returns a ColorIdentity object" do
      expect(subject.class).to eq Card::ColorIdentity
    end
  end
end
