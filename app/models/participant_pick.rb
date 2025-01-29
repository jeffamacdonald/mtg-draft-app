# t.references :draft_participant, references: :draft_participants, foreign_key: { to_table: :draft_participants }
# t.references :cube_card, references: :cube_cards, foreign_key: { to_table: :cube_cards }
# t.integer :pick_number, null: false
# t.integer :round, null: false
# t.string :comment
# t.boolean :skipped
# t.timestamps null: false

class ParticipantPick < ApplicationRecord
  belongs_to :draft_participant
  belongs_to :cube_card, optional: true
  delegate :draft, to: :draft_participant
  delegate :card, :color_identity, to: :cube_card, allow_nil: true
  delegate :name, to: :card, allow_nil: true
  validate :availability

  scope :for_round, ->(round) { where(round: round) }
  scope :ordered, -> { order(:pick_number) }

  private

  def availability
    return unless cube_card_id.present?

    draft.draft_participants.each do |participant|
      unless participant.participant_picks.select { |pick| pick.cube_card_id == cube_card_id }.empty?
        errors.add(:cube_card_id, 'Card Is Not Available')
      end
    end
  end
end
