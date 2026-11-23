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

  describe "#cube_list_cache_key" do
    let(:draft) { create :draft }
    let(:draft_participant) { create :draft_participant, draft: }
    let(:first_card) { create :cube_card, cube: draft.cube }
    let(:second_card) { create :cube_card, cube: draft.cube }

    def key_for(draft_record, filters = {})
      described_class.for_active_draft(draft: draft_record, draft_participant:, text_only: false, image_size: "lg")
        .cube_list_cache_key(filters)
    end

    it "is the same in any process and for the same picks, whatever order they were made in" do
      create :participant_pick, draft_participant:, cube_card: first_card, pick_number: 1
      create :participant_pick, draft_participant:, cube_card: second_card, pick_number: 2

      expect(key_for(Draft.find(draft.id))).to eq(key_for(Draft.find(draft.id)))
      expect(key_for(Draft.find(draft.id))).to include(a_string_matching(/\A\h{40}\z/))
    end

    it "changes when a card is picked or the filters change" do
      before_pick = key_for(Draft.find(draft.id))
      create :participant_pick, draft_participant:, cube_card: first_card

      expect(key_for(Draft.find(draft.id))).not_to eq(before_pick)
      expect(key_for(Draft.find(draft.id), { cmc: "1" })).not_to eq(key_for(Draft.find(draft.id)))
    end
  end
end
