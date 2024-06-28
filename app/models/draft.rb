# t.references :cube, references: :cubes, foreign_key: { to_table: :cubes }
# t.references :user, references: :users, foreign_key: { to_table: :users }
# t.string :name, null: false
# t.integer :rounds, null: false
# t.integer :timer_minutes
# t.string :status, null: false
# t.integer :active_round
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

  def set_participant_positions
    draft_participants.shuffle.each.with_index do |participant, i|
      participant.update(draft_position: i + 1)
    end
  end

  def active_participant
    if active_round == 1
      first_round_active_participant
    elsif last_pick_number % draft_participants.count == 0
      edge_case_active_participant
    else
      standard_active_participant
    end
  end

  def last_pick_number
    participant_picks.maximum(:pick_number)
  end

  def timer_live?
    timer_minutes.present? && current_round > 2
  end

  def enqueue_skip_job(draft_participant)
    if timer_live?
      SkipActiveParticipantJob.set(wait: seconds_until_skip).perform_later(self, draft_participant, last_pick_number)
    end
  end

  private

  def current_round
    last_pick_number / draft_participants.count + 1
  end

  def seconds_until_skip
    TimerCalculator.new(last_pick_at, timer_minutes).calculate_target_end.to_i - Time.now.to_i
  end

  def current_pick_number
    num = last_pick_number + 1
    while skipped_participants.any? { |participant| participant.all_pick_numbers.include?(num) }
      num += 1
    end
    num
  end

  def standard_active_participant
    ordered_participants.find do |participant|
      participant.next_pick_number == current_pick_number
    end
  end

  def first_round_active_participant
    ordered_participants
      .left_outer_joins(:participant_picks)
      .where(participant_picks: { id: nil })
      .first
  end

  def edge_case_active_participant
    ordered_participants.find do |participant|
      participant.participant_picks.ordered.last.pick_number <= last_pick_number
    end
  end

  def ordered_participants
    if active_round.odd?
      draft_participants.unskipped.ordered
    else
      draft_participants.unskipped.reversed
    end
  end

  def skipped_participants
    draft_participants.skipped
  end
end
