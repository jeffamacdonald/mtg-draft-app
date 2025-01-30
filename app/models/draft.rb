# t.references :cube, references: :cubes, foreign_key: { to_table: :cubes }
# t.references :user, references: :users, foreign_key: { to_table: :users }
# t.string :name, null: false
# t.integer :rounds, null: false
# t.integer :timer_minutes
# t.string :status, null: false
# t.datetime :last_pick_at
# t.timestamps null: false

class Draft < ApplicationRecord
  belongs_to :cube
  belongs_to :owner, foreign_key: :user_id, class_name: "User"
  has_many :draft_participants
  has_many :users, :through => :draft_participants
  has_many :participant_picks, :through => :draft_participants
  has_many :draft_chat_messages
  enum :status, DraftStatus.all.zip(DraftStatus.all).to_h

  scope :pending, -> { where(status: DraftStatus.pending) }

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
    active_pick.draft_participant
  end

  def last_pick_number
    participant_picks.where.not(cube_card_id: nil)
      .or(
        participant_picks.where(skipped: true)
      ).maximum(:pick_number) || 0
  end

  def timer_live?
    active? && timer_minutes.present? && active_round > 2
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

  def active_round
    active_pick.round
  end
end
