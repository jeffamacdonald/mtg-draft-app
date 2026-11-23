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

  describe "#land? and #colorless?" do
    it "identifies a land" do
      expect(described_class.new([ "L" ])).to be_land
      expect(described_class.new([ "L" ])).not_to be_colorless
    end

    it "identifies a colorless card" do
      expect(described_class.new([ "C" ])).to be_colorless
      expect(described_class.new([ "C" ])).not_to be_land
    end

    it "treats colored cards as neither" do
      expect(described_class.new([ "W", "U" ])).not_to be_land
      expect(described_class.new([ "W", "U" ])).not_to be_colorless
    end
  end

  describe "class strings" do
    it "returns the same background class on repeated calls" do
      identity = described_class.new([ "B" ])

      expect(identity.background_class).to equal(identity.background_class)
      expect(identity.background_class).to eq "bg-black"
    end

    it "only uses white text on black" do
      expect(described_class.new([ "B" ]).text_class).to eq "text-white"
      expect(described_class.new([ "W" ]).text_class).to be_nil
      expect(described_class.new([ "B", "R" ]).text_class).to be_nil
    end
  end
end
