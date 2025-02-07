# t.references :draft_participant, references: :draft_participants, foreign_key: { to_table: :draft_participants }
# t.references :cube_card, references: :cube_cards, foreign_key: { to_table: :cube_cards }
# t.integer :priority_number, null: false
# t.timestamps null: false

class QueuedPick < ApplicationRecord
  belongs_to :draft_participant
  belongs_to :cube_card

  def handle_cube_card_picked!
    ActiveRecord::Base.transaction do
      lower_priority_picks = draft_participant.queued_picks.where("priority_number > ?", priority_number).order(:priority_number)
      lower_priority_picks.each do |qp|
        qp.update!(priority_number: qp.priority_number - 1)
      end
      self.destroy!
    end
  end
end
