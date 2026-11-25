require "rails_helper"

RSpec.describe DraftListComponent, type: :component do
  let(:user) { create(:user) }
  let(:cube) { create(:cube) }

  def draft_with(status:, participant: nil)
    create(:draft, cube:, status:).tap do |draft|
      create(:draft_participant, draft:, user: participant) if participant
    end
  end

  it "splits drafts into the user's own, joinable pending, and spectatable active" do
    own_pending = draft_with(status: DraftStatus.pending, participant: user)
    own_active = draft_with(status: DraftStatus.active, participant: user)
    joinable = draft_with(status: DraftStatus.pending)
    spectatable = draft_with(status: DraftStatus.active)
    draft_with(status: DraftStatus.completed)

    component = described_class.new(user:)

    expect(component.instance_variable_get(:@active_drafts)).to contain_exactly(own_pending, own_active)
    expect(component.instance_variable_get(:@pending_drafts)).to contain_exactly(joinable)
    expect(component.instance_variable_get(:@spectator_drafts)).to contain_exactly(spectatable)
  end
end
