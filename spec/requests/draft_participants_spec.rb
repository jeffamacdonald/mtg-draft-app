require 'rails_helper'

RSpec.describe DraftParticipantsController, type: :request do
  describe 'GET #new' do
    let(:draft) { create(:draft) }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get new_draft_participant_path(draft_id: draft.id)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:draft) { create(:draft) }
    let(:user) { create(:user) }
    let(:valid_params) do
      {
        draft_participant: {
          draft_id: draft.id,
          user_id: user.id,
          display_name: 'Participant 1'
        }
      }
    end

    before do
      sign_in user
    end

    context 'with valid parameters' do
      it 'creates a new draft participant' do
        expect {
          post draft_participants_path, params: valid_params
        }.to change { DraftParticipant.count }.by(1)
      end

      it 'redirects to the draft show page' do
        post draft_participants_path, params: valid_params
        expect(response).to redirect_to(draft_path(draft))
      end
    end
  end
end
