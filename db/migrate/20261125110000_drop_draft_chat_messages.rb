# The chat feature was removed from the app. Rolling back recreates the table's structure only (not its data).
class DropDraftChatMessages < ActiveRecord::Migration[7.1]
  def change
    drop_table :draft_chat_messages, id: :uuid do |t|
      t.references :user, type: :uuid
      t.references :draft, type: :uuid
      t.references :participant_pick, type: :uuid
      t.string :text, null: false

      t.timestamps
    end
  end
end
