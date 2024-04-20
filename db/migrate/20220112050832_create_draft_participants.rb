class CreateDraftParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :draft_participants, id: :uuid do |t|
      t.references :draft, references: :drafts, foreign_key: { to_table: :drafts }, type: :uuid
      t.references :user, references: :users, foreign_key: { to_table: :users }, type: :uuid
      t.references :surrogate_user, references: :users, foreign_key: { to_table: :users }, type: :uuid
      t.string :display_name, null: false
      t.integer :draft_position
      t.boolean :skipped
      t.timestamps null: false
    end

    add_index :draft_participants, [:draft_id, :draft_position], unique: true
    add_index :draft_participants, [:draft_id, :user_id], unique: true
  end
end
