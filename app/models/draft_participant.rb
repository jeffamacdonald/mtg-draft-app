# t.references :draft, references: :drafts, foreign_key: { to_table: :drafts }
# t.references :user, references: :users, foreign_key: { to_table: :users }
# t.references :surrogate_user, references: :users, foreign_key: { to_table: :users }
# t.string :display_name, null: false
# t.integer :draft_position
# t.boolean :skipped
# t.timestamps null: false

class DraftParticipant < ApplicationRecord
  belongs_to :draft
  belongs_to :user
  has_many :participant_picks
  has_many :cube_cards, :through => :participant_picks
  has_many :surrogate_draft_participants
  has_many :surrogate_participants, through: :surrogate_draft_participants

  scope :unskipped, -> { where(skipped: false) }
  scope :skipped, -> { where(skipped: true) }
  scope :ordered, -> { order(:draft_position) }
  scope :reversed, -> { order(draft_position: :desc) }

  def pick_card!(cube_card)
    round = next_pick_round
    pick_number = calculate_pick_number(round)
    pick = ParticipantPick.create!(draft_participant: self, cube_card: cube_card,
      round: round, pick_number: pick_number)
    if skipped?
      if draft.last_pick_number < next_pick_number
        update!(skipped: false)
      end
    else
      draft.update!(last_pick_at: pick.created_at)
      draft.enqueue_skip_job(draft.reload.active_participant)
    end
    pick
  end

  def next_pick_number
    calculate_pick_number(next_pick_round)
  end

  def edge_case?
    draft_position == 1 || draft_position == draft.draft_participants.count
  end

  def last_pick
    participant_picks.reload.last
  end

  def all_pick_numbers
    pick_numbers = []
    draft.rounds.times do |i|
      pick_numbers << calculate_pick_number(i + 1)
    end
    pick_numbers
  end

  private

  def next_pick_round
    last_pick.nil? ? 1 : last_pick.round + 1
  end

  def calculate_pick_number(round)
    total_drafters = draft.draft_participants.count
    if round % 2 == 1
      ((round-1) * total_drafters + draft_position)
    else
      round * total_drafters - draft_position + 1
    end
  end
end
