class CreateQueuedPicks < ActiveRecord::Migration[7.1]
  def change
    create_table :queued_picks, id: :uuid do |t|
      t.references :draft_participant, foreign_key: { to_table: :draft_participants }, type: :uuid
      t.references :cube_card, foreign_key: { to_table: :cube_cards }, type: :uuid
      t.integer :priority_number, null: false

      t.timestamps
    end
  end
end
