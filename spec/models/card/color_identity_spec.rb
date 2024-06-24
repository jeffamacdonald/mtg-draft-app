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

  describe "#background_class" do
    subject { color_identity.background_class }

    context "when there is more than one color identity" do
      it "returns gold" do
        expect(subject).to eq "bg-gold"
      end
    end

    context "when there is only one color identity" do
      let(:color_identities) { ["U"] }

      it "returns based on color map" do
        expect(subject).to eq "bg-blue"
      end

      context "when the color identity is land" do
        let(:color_identities) { ["L"] }

        it "returns peach" do
          expect(subject).to eq "bg-peach"
        end
      end

      context "when the color identity is colorless" do
        let(:color_identities) { ["C"] }

        it "returns gray" do
          expect(subject).to eq "bg-gray"
        end
      end
    end
  end

  describe "#text_class" do
    subject { color_identity.text_class }

    context "when background class is black" do
      let(:color_identities) { ["B"] }

      it "returns text-white" do
        expect(subject).to eq "text-white"
      end
    end

    context "when background class is anything else" do
      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
