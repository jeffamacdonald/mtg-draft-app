class CreateSurrogateDraftParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :surrogate_draft_participants, id: :uuid do |t|
      t.references :draft_participant, foreign_key: { to_table: :draft_participants }, type: :uuid
      t.references :surrogate_participant, foreign_key: { to_table: :draft_participants }, type: :uuid

      t.timestamps
    end
  end
end
