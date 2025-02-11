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

  describe 'GET #edit' do
    let(:draft) { create(:draft) }
    let(:user) { create(:user) }
    let(:draft_participant) { create(:draft_participant, draft: draft, user: user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get edit_draft_participant_path(draft_participant)
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    let(:draft) { create(:draft) }
    let(:user) { create(:user) }
    let(:draft_participant) { create(:draft_participant, draft: draft, user: user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      patch draft_participant_path(draft_participant), params: {draft_participant: {display_name: "new", queue_active: true, queue_minute_delay: 60}}
      expect(response).to redirect_to(draft_path(draft))
      expect(draft_participant.reload.display_name).to eq "new"
    end
  end

  describe 'GET #picks' do
    let(:draft) { create(:draft) }
    let(:user) { create(:user) }
    let(:draft_participant) { create(:draft_participant, draft: draft) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get picks_draft_participant_path(draft_participant)
      expect(response).to be_successful
    end
  end

  describe 'GET #pick_queue' do
    let(:draft) { create(:draft) }
    let(:user) { create(:user) }
    let(:draft_participant) { create(:draft_participant, draft: draft, user: user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get pick_queue_draft_participant_path(draft_participant)
      expect(response).to be_successful
    end

    context "when draft participant is not current user" do
      let(:draft_participant) { create(:draft_participant, draft: draft) }
      it "redirects to draft" do
        get pick_queue_draft_participant_path(draft_participant)
        expect(response).to redirect_to draft_path(draft)
      end
    end
  end
end
