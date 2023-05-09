class CreateParticipantPicks < ActiveRecord::Migration[7.0]
  def change
    create_table :participant_picks do |t|
      t.references :draft_participant, references: :draft_participants, foreign_key: { to_table: :draft_participants }
      t.references :cube_card, references: :cube_cards, foreign_key: { to_table: :cube_cards }
      t.integer :pick_number, null: false
      t.integer :round, null: false
      t.timestamps null: false
    end

    add_index :participant_picks, :round
  end
end
