# == Schema Information
#
# Table name: draft_chat_messages
#
#  id                  :uuid             not null, primary key
#  text                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  draft_id            :uuid
#  participant_pick_id :uuid
#  user_id             :uuid
#
# Indexes
#
#  index_draft_chat_messages_on_draft_id             (draft_id)
#  index_draft_chat_messages_on_participant_pick_id  (participant_pick_id)
#  index_draft_chat_messages_on_user_id              (user_id)
#
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
