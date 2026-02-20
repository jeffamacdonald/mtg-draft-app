require 'rails_helper'

RSpec.describe 'ParticipantPicks', type: :request do
  let(:user) { create(:user) }
  let(:cube) { create(:cube, owner: user) }
  let(:draft) { create(:draft, cube:, owner: user, status: 'active') }
  let(:draft_participant) { create(:draft_participant, draft:) }
  let(:cube_card) { create(:cube_card, cube:) }

  before do
    sign_in user
  end

  describe 'GET /participant_picks/new' do
    it 'renders the new pick form' do
    #   TODO
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        get new_participant_pick_path, params: {
          draft_participant_id: draft_participant.id,
          cube_card_id: cube_card.id
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /participant_picks' do
    let(:pick_params) do
      {
        participant_pick: {
          draft_participant_id: draft_participant.id,
          cube_card_id: cube_card.id
        }
      }
    end

    it 'creates a participant pick and redirects' do
    #   TODO
    end

    it 'sends email to next participant when different from current user' do
    #   TODO
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        post participant_picks_path, params: pick_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /participant_picks/:id' do
    let(:participant_pick) { create(:participant_pick, draft_participant: draft_participant) }
    let(:update_params) do
      {
        id: participant_pick.id,
        participant_pick: { comment: 'Great card!' }
      }
    end

    it 'updates the participant pick comment' do
      patch participant_pick_path(participant_pick), params: update_params, as: :turbo_stream

      participant_pick.reload
      expect(participant_pick.comment).to eq('Great card!')
      expect(response).to have_http_status(:success)
    end

    it 'broadcasts the update' do
      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to)

      patch participant_pick_path(participant_pick), params: update_params, as: :turbo_stream
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        patch participant_pick_path(participant_pick), params: update_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /participant_picks/:id/hovercard' do
    let(:participant_pick) { create(:participant_pick, draft_participant: draft_participant) }

    it 'renders hovercard without layout' do
      get hovercard_participant_pick_path(participant_pick)

      expect(response).to have_http_status(:success)
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        get hovercard_participant_pick_path(participant_pick)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
