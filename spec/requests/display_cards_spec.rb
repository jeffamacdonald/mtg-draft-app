require 'rails_helper'

RSpec.describe DisplayCardsController, type: :request do
  let!(:user) { create(:user) }
  let!(:cube) { create(:cube, owner: user) }
  let!(:cube_card) { create(:cube_card, cube: cube) }
  let(:picked_card) { create(:cube_card, cube: cube) }
  let!(:draft) { create(:draft, cube: cube) }
  let!(:participant) { create(:draft_participant, draft: draft, user: user) }
  let!(:other_participant) { create(:draft_participant, draft: draft) }
  let!(:another_participant) { create(:draft_participant, draft: draft) }
  let(:active_participant) { another_participant }
  let!(:last_pick) { create(:participant_pick, draft_participant: other_participant, cube_card_id: picked_card.id, round: 1, pick_number: 1) }
  let!(:current_pick) { create(:participant_pick, draft_participant: active_participant, cube_card_id:  nil, round: 1, pick_number: 2) }

  before do
    sign_in user
  end

  context "when a draft exists" do
    context "when card has been picked" do
      let(:picked_card) { cube_card }

      it "renders the cube card path" do
        get route_display_card_path, params: { cube_card_id: cube_card.id, draft_id: draft.id }
        expect(response).to redirect_to(cube_card_path(cube_card))
      end
    end

    context "when card has not been picked" do
      context "when the current participant is skipped" do
        let!(:participant) { create(:draft_participant, draft: draft, user: user, skipped: true) }

        it "renders the new participant pick path" do
          get route_display_card_path, params: { cube_card_id: cube_card.id, draft_id: draft.id }
          expect(response).to redirect_to(new_participant_pick_path(cube_card_id: cube_card.id, draft_participant_id: participant.id))
        end
      end

      context "when the current participant can pick for the active participant" do
        let(:active_participant) { participant }

        it "renders the new participant pick path" do
          get route_display_card_path, params: { cube_card_id: cube_card.id, draft_id: draft.id }
          expect(response).to redirect_to(new_participant_pick_path(cube_card_id: cube_card.id, draft_participant_id: participant.id))
        end
      end

      context "when the current participant cannot pick" do
        it "renders the new queued pick path" do
          get route_display_card_path, params: { cube_card_id: cube_card.id, draft_id: draft.id }
          expect(response).to redirect_to(new_queued_pick_path(cube_card_id: cube_card.id, draft_participant_id: participant.id))
        end
      end
    end
    
  end

  context "when no draft exists" do
    context "when the current user owns the cube" do
      it "renders the edit cube card path" do
        get route_display_card_path, params: { cube_card_id: cube_card.id }
        expect(response).to redirect_to(edit_cube_card_path(cube_card))
      end
    end

    context "when the current user does not own the cube" do
      let(:other_user) { create(:user) }
      before { sign_in other_user }

      it "renders the cube card path" do
        get route_display_card_path, params: { cube_card_id: cube_card.id }
        expect(response).to redirect_to(cube_card_path(cube_card))
      end
    end
  end
end
