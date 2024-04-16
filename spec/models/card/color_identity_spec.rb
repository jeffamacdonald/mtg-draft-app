require 'rails_helper'

RSpec.describe Card::ColorIdentity do
  let(:color_identity) { described_class.new(color_identities) }
  let(:color_identities) { ["U", "R"] }

  describe "#display_identity" do
    subject { color_identity.display_identity }

    it "returns the long name" do
      expect(subject).to eq "red blue"
    end
  end
end
