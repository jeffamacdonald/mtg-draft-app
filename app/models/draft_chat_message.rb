# t.references :user, type: :uuid
# t.references :draft, type: :uuid
# t.string :text, null: false
# t.timestamps

class DraftChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :draft
  after_create_commit { broadcast_prepend_to "draft_chat_messages" }

  def participant_name
    draft.draft_participants.find_by(user: user)&.display_name || user.username
  end
end
