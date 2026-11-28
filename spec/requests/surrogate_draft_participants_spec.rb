require 'rails_helper'

RSpec.describe SurrogateDraftParticipantsController, type: :request do
  let(:user) { create(:user) }
  let(:draft) { create(:draft) }
  let(:own_participant) { create(:draft_participant, draft:, user:) }
  let!(:other_participant) { create(:draft_participant, draft:) }

  before { sign_in user }

  def params_for(draft_participant, surrogate)
    { surrogate_draft_participant: { draft_participant_id: draft_participant.id, surrogate_participant_id: surrogate.id } }
  end

  describe "managing your own surrogates" do
    it "shows the dialog" do
      get new_surrogate_draft_participant_path(draft_participant_id: own_participant.id)

      expect(response).to be_successful
    end

    it "adds a surrogate" do
      expect {
        post surrogate_draft_participants_path, params: params_for(own_participant, other_participant)
      }.to change(SurrogateDraftParticipant, :count).by(1)

      expect(response).to redirect_to(draft_path(draft))
    end
  end

  describe "managing another drafter's surrogates" do
    it "does not show the dialog" do
      get new_surrogate_draft_participant_path(draft_participant_id: other_participant.id)

      expect(response).to redirect_to(draft_path(draft))
      expect(flash[:error]).to include("your own drafter")
    end

    it "does not let you make yourself their surrogate" do
      expect {
        post surrogate_draft_participants_path, params: params_for(other_participant, own_participant)
      }.not_to change(SurrogateDraftParticipant, :count)

      expect(response).to redirect_to(draft_path(draft))
    end
  end
end
