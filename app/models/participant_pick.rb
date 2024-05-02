# t.references :draft_participant, references: :draft_participants, foreign_key: { to_table: :draft_participants }
# t.references :cube_card, references: :cube_cards, foreign_key: { to_table: :cube_cards }
# t.integer :pick_number, null: false
# t.integer :round, null: false
# t.timestamps null: false

class ParticipantPick < ApplicationRecord
  belongs_to :draft_participant
  belongs_to :cube_card
  delegate :draft, to: :draft_participant
  delegate :card, to: :cube_card
  delegate :name, to: :card
  validate :availability

  scope :for_round, ->(round) { where(round: round) }
  scope :ordered, -> { order(:pick_number) }

  after_save :update_draft_round

  private

  def availability
    draft.draft_participants.each do |participant|
      unless participant.participant_picks.select { |pick| pick.cube_card_id == cube_card_id }.empty?
        errors.add(:cube_card_id, 'Card Is Not Available')
      end
    end
  end

  def update_draft_round
    return if pick_number == draft.draft_participants.count * draft.rounds

    if draft.participant_picks.ordered.last == self
      if pick_number % draft.draft_participants.count == 0
        draft.update!(active_round: round + 1)
      else
        draft.update!(active_round: round)
      end
    end
  end
end
