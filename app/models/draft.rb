# == Schema Information
#
# Table name: drafts
#
#  id                 :uuid             not null, primary key
#  last_pick_at       :datetime
#  name               :string           not null
#  participants_count :integer          default(0), not null
#  rounds             :integer          not null
#  status             :string           not null
#  timer_minutes      :integer
#  transfers_allowed  :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cube_id            :uuid
#  user_id            :uuid
#
# Indexes
#
#  index_drafts_on_cube_id  (cube_id)
#  index_drafts_on_name     (name)
#  index_drafts_on_status   (status)
#  index_drafts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cube_id => cubes.id)
#  fk_rails_...  (user_id => users.id)
#
class Draft < ApplicationRecord
  belongs_to :cube
  belongs_to :owner, foreign_key: :user_id, class_name: "User"
  has_many :draft_participants, counter_cache: :participants_count
  has_many :users, :through => :draft_participants
  has_many :participant_picks, :through => :draft_participants
  has_many :draft_chat_messages
  has_many :transfer_portal_transactions
  has_many :transfer_portal_transaction_offerings, :through => :transfer_portal_transactions
  enum :status, DraftStatus.all.zip(DraftStatus.all).to_h

  scope :pending, -> { where(status: DraftStatus.pending) }
  scope :with_full_associations, -> {
    includes(
      :cube,
      draft_participants: :user,
      participant_picks: [
        :draft_participant,
        { cube_card: :card }
      ]
    )
  }

  def set_participant_positions!
    draft_participants.shuffle.each.with_index do |participant, i|
      participant.update(draft_position: i + 1)
    end
  end

  def setup_picks!
    draft_participants.order(:draft_position).each do |draft_participant|
      rounds.times.with_index do |i|
        draft_participant.participant_picks.create!(round: i + 1, pick_number: draft_participant.calculate_pick_number(i + 1))
      end
    end
  end

  def active_pick
    participant_picks.find_by(pick_number: last_pick_number + 1)
  end

  def active_participant
    active_pick&.draft_participant
  end

  def last_pick_number
    participant_picks.where.not(cube_card_id: nil)
      .or(
        participant_picks.where(skipped: true)
      ).maximum(:pick_number) || 0
  end

  def timer_live?
    active? && timer_minutes.present? && after_initial_rounds?
  end

  def enqueue_skip_job
    if timer_live?
      SkipActiveParticipantJob.set(wait: seconds_until_skip).perform_later(active_pick)
    end
  end

  private

  def seconds_until_skip
    return 0 if active_participant.skipped?

    TimerCalculator.new(last_pick_at, timer_minutes).calculate_target_end.to_i - Time.now.to_i
  end

  def after_initial_rounds?
    return false unless active_pick.present?
    active_pick.round > 2
  end
end
