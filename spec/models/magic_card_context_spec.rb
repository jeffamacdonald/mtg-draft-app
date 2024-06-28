require 'rails_helper'

RSpec.describe MagicCardContext do
  describe "#picked?" do
    let(:cube_card) { create :cube_card }

    context "when draft is not present" do
      it "returns false" do
        magic_card_context = MagicCardContext.for_cube(cube: cube_card.cube, text_only: nil, image_size: nil)

        expect(magic_card_context.picked?(cube_card)).to eq false
      end
    end

    context "when draft is present" do
      let(:draft) { create :draft }
      let(:draft_participant) { create :draft_participant, draft: }

      context "when card has been picked" do
        it "returns true" do
          FactoryBot.create(:participant_pick, draft_participant:, cube_card:)
          magic_card_context = MagicCardContext.for_active_draft(draft:, draft_participant:, text_only: nil, image_size: nil)
          expect(magic_card_context.picked?(cube_card)).to eq true
        end
      end

      context "when card has not been picked" do
        it "returns false" do
          magic_card_context = MagicCardContext.for_active_draft(draft:, draft_participant:, text_only: nil, image_size: nil)
          expect(magic_card_context.picked?(cube_card)).to eq false
        end
      end
    end
  end

  describe "#text_only?" do
    it "returns the value of text_only" do
      magic_card_context = MagicCardContext.for_view_only
      expect(magic_card_context.text_only?).to eq false
    end
  end
end
