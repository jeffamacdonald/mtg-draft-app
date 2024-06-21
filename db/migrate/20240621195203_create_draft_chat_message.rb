class CreateDraftChatMessage < ActiveRecord::Migration[7.1]
  def change
    create_table :draft_chat_messages, id: :uuid do |t|
      t.references :user, type: :uuid
      t.references :draft, type: :uuid
      t.string :text, null: false

      t.timestamps
    end
  end
end
