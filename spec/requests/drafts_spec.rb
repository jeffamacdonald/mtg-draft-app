require 'rails_helper'

RSpec.describe DraftsController, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get drafts_path
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get new_draft_path
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:draft) { create(:draft) }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get draft_path(draft)
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context 'when the draft status is pending' do
      let(:draft) { create(:draft, status: DraftStatus.pending) }

      it 'returns a successful response' do
        get edit_draft_path(draft)
        expect(response).to be_successful
      end
    end

    context 'when the draft status is not pending' do
      let(:draft) { create(:draft, status: DraftStatus.active) }

      it 'redirects to the draft show page' do
        get edit_draft_path(draft)
        expect(response).to redirect_to(draft_path(draft))
      end
    end
  end

  describe 'PATCH #update' do
    let(:draft) { create(:draft) }
    let(:valid_params) { { status: DraftStatus.active } }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'updates the draft' do
      patch draft_path(draft), params: { draft: valid_params }
      expect(draft.reload.status).to eq(DraftStatus.active)
    end

    it 'redirects to the draft show page' do
      patch draft_path(draft), params: { draft: valid_params }
      expect(response).to redirect_to(draft_path(draft))
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:cube) { create(:cube) }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          draft: {
            name: 'Test Draft',
            rounds: 3,
            cube_id: cube.id
          }
        }
      end

      before do
        sign_in user
      end

      it 'creates a new draft with one participant' do
        expect {
          post drafts_path, params: valid_params
        }.to change { Draft.count }.by(1)
          .and change { DraftParticipant.count }.by(1)
        expect(DraftParticipant.last.display_name).to eq user.username
      end

      it 'redirects to the drafts index page' do
        post drafts_path, params: valid_params
        expect(response).to redirect_to(drafts_path)
      end
    end

    context 'when not authenticated' do
      let(:invalid_params) do
        {
          draft: {
            name: 'Test Draft',
            rounds: 3,
            cube_id: cube.id
          }
        }
      end

      it 'does not create a new draft' do
        expect {
          post drafts_path, params: invalid_params
        }.to_not change { Draft.count }
      end

      it 'redirects to the sign-in page' do
        post drafts_path, params: invalid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
