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
class DraftChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :participant_pick, optional: true
  belongs_to :draft
  after_create_commit { broadcast_append_to "draft_chat_messages" }

  def participant_name
    draft.draft_participants.find_by(user: user)&.display_name || user&.username
  end
end
