require 'rails_helper'

RSpec.describe DraftChatMessage do
  describe "#participant_name" do
    let(:draft) { create :draft }
    let(:user) { create :user, username: "username" }
    let(:draft_chat_message) { create :draft_chat_message, draft:, user: }

    context "when draft participant exists" do
      let!(:draft_participant) { create :draft_participant, draft:, user:, display_name: "display_name" }

      it "returns draft participant display_name" do
        expect(draft_chat_message.participant_name).to eq "display_name"
      end
    end

    context "when draft participant does not exist" do
      it "returns user username" do
        expect(draft_chat_message.participant_name).to eq "username"
      end
    end
  end
end
