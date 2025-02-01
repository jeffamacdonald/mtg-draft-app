# t.references :draft_participant, references: :draft_participants, foreign_key: { to_table: :draft_participants }
# t.references :cube_card, references: :cube_cards, foreign_key: { to_table: :cube_cards }
# t.integer :priority_number, null: false
# t.timestamps null: false

class QueuedPick < ApplicationRecord
  belongs_to :draft_participant
  belongs_to :cube_card
end
