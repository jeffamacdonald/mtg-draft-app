class AddPickToDraftChatMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :draft_chat_messages, :participant_pick, index: true, type: :uuid
  end
end
