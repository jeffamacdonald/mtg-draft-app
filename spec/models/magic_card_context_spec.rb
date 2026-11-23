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

  describe "#card_route_path" do
    let(:urls) { Rails.application.routes.url_helpers }
    let(:cube_card) { create :cube_card }
    let(:other_cube_card) { create :cube_card }

    it "matches the route helper for each card, including the draft id" do
      draft = create :draft
      context = MagicCardContext.for_active_draft(draft:, draft_participant: nil, text_only: nil, image_size: nil)

      [ cube_card, other_cube_card ].each do |card|
        expect(context.card_route_path(card)).to eq(urls.route_display_card_path(cube_card_id: card.id, draft_id: draft.id))
      end
    end

    it "omits the draft id when there is no draft" do
      context = MagicCardContext.for_cube(cube: cube_card.cube, text_only: nil, image_size: nil)

      expect(context.card_route_path(cube_card)).to eq(urls.route_display_card_path(cube_card_id: cube_card.id))
    end
  end
end
