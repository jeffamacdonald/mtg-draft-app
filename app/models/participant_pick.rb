# == Schema Information
#
# Table name: participant_picks
#
#  id                   :uuid             not null, primary key
#  comment              :string           default("")
#  pick_number          :integer          not null
#  round                :integer          not null
#  skipped              :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cube_card_id         :uuid
#  draft_participant_id :uuid
#
# Indexes
#
#  index_participant_picks_on_card_and_round               (cube_card_id,round)
#  index_participant_picks_on_cube_card_id                 (cube_card_id)
#  index_participant_picks_on_draft_participant_id         (draft_participant_id)
#  index_participant_picks_on_participant_and_pick_number  (draft_participant_id,pick_number)
#  index_participant_picks_on_round                        (round)
#
# Foreign Keys
#
#  fk_rails_...  (cube_card_id => cube_cards.id)
#  fk_rails_...  (draft_participant_id => draft_participants.id)
#
class ParticipantPick < ApplicationRecord
  belongs_to :draft_participant
  belongs_to :cube_card, optional: true
  # Lightweight cube card for the pick grid: only the columns a pick cell renders
  # (id, custom_color_identity, name). Preload this instead of cube_card: :card.
  belongs_to :grid_cube_card,
    -> { joins(:card).select("cube_cards.id", "cube_cards.custom_color_identity", "cards.name") },
    class_name: "CubeCard", foreign_key: :cube_card_id, optional: true
  delegate :draft, to: :draft_participant
  delegate :card, :color_identity, to: :cube_card, allow_nil: true
  delegate :name, to: :card, allow_nil: true
  validate :availability, if: :will_save_change_to_cube_card_id?

  scope :for_round, ->(round) { where(round: round) }
  scope :ordered, -> { order(:pick_number) }

  def enqueue_auto_pick_job
    PickNextQueuedPickJob.set(wait: seconds_until_auto_pick).perform_later(self)
  end

  def display_name
    cube_card&.card&.name || "Round #{round} Pick"
  end

  def transfered?
    draft_participant.calculate_pick_number(round) != pick_number
  end

  private

  def availability
    return unless cube_card_id.present?

    if draft.participant_picks.where(cube_card_id:).where.not(id:).exists?
      errors.add(:cube_card_id, 'Card Is Not Available')
    end
  end

  def seconds_until_auto_pick
    # Add 60 seconds to avoid race conditions
    (draft_participant.queue_minute_delay * 60) + 60
  end
end
