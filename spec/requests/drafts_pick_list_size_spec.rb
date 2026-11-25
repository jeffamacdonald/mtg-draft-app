require "rails_helper"

RSpec.describe "POST /drafts/:id/pick_list_size", type: :request do
  let(:draft) { create(:draft, status: DraftStatus.active) }
  let(:user) { create(:draft_participant, draft: draft).user }

  before { sign_in user }

  it "renders the pick list with the newly chosen size" do
    post pick_list_size_draft_path(draft), params: { text_size: "small-text" }, as: :turbo_stream

    expect(user.reload.pick_list_size).to eq("small-text")
    expect(response.body).to include("table-bordered font-display small-text")
  end
end
