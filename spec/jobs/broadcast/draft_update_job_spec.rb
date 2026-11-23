require "rails_helper"

RSpec.describe Broadcast::DraftUpdateJob, type: :job do
  let!(:draft) { create :draft }
  let!(:dp1) { create :draft_participant, draft:, draft_position: 1 }
  let!(:dp2) { create :draft_participant, draft:, draft_position: 2 }
  let!(:dp3) { create :draft_participant, draft:, draft_position: 3 }

  def broadcasts
    calls = []
    allow(Turbo::StreamsChannel).to receive(:broadcast_replace_to) { |user, **opts| calls << [ user, opts ] }
    described_class.perform_now(draft)
    calls
  end

  it "performs turbo stream replace to each user" do
    expect(broadcasts.map(&:first)).to match_array([ dp1.user, dp2.user, dp3.user ])
  end

  it "targets the draft show body" do
    expect(broadcasts.map { |_, opts| opts[:target] }.uniq).to eq([ "draft_#{draft.id}_show_body" ])
  end

  it "renders once and shares the HTML when users have the same display settings" do
    expect(ApplicationController).to receive(:render).once.and_call_original
    expect(broadcasts.map { |_, opts| opts[:content] }.uniq.size).to eq(1)
  end

  it "renders separately for users with different display settings" do
    dp2.user.update_columns(default_display: "text")
    dp3.user.update_columns(pick_list_size: "small-text")
    expect(ApplicationController).to receive(:render).exactly(3).times.and_call_original
    expect(broadcasts.map { |_, opts| opts[:content] }.uniq.size).to eq(3)
  end

  it "does not query per user" do
    (4..8).each { |position| create :draft_participant, draft: draft, draft_position: position }
    described_class.perform_now(draft) # warm-up
    queries = 0
    sub = ActiveSupport::Notifications.subscribe("sql.active_record") { |*, p| queries += 1 unless p[:name] == "SCHEMA" }
    described_class.perform_now(draft)
    ActiveSupport::Notifications.unsubscribe(sub)
    expect(queries).to be <= 15
  end
end
