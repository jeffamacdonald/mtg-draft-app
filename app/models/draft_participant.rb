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
      if pick_number == draft.draft_participants.count * draft.rounds
        draft.completed!
      else
        draft.enqueue_skip_job(draft.reload.active_participant)
      end
    end
    Broadcast::DraftUpdateJob.perform_later(draft)
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

  def can_pick_for?(draft_participant)
    draft_participant == self || draft_participant.surrogate_participants.include?(self)
  end

  def cardpool
    cube_cards.sort_by(&:custom_cmc).map do |cube_card|
      cube_card.card.name
    end
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

  # def broadcast_updates
  #   draft.users.each do |user|
  #     context = MagicCardContext.for_active_draft(
  #       draft: draft, 
  #       draft_participant: draft.draft_participants.find_by(user: user), 
  #       text_only: user.default_display == "text", 
  #       image_size: user.default_image_size)
  #     chat_messages = draft.draft_chat_messages
  #       .joins(:user)
  #       .select(
  #         "draft_chat_messages.*",
  #         "users.username AS username"
  #       )
  #       .order(created_at: :desc)
  #     cube_cards = draft.cube.cube_cards
  #       .select(
  #         "cube_cards.*",
  #         "cards.name",
  #         "cards.type_line",
  #         "cards.card_text"
  #       )
  #       .active.sorted
  #     Turbo::StreamsChannel.broadcast_replace_to(
  #       user,
  #       target: "draft_#{draft.id}_show_body",
  #       partial: "drafts/show_body",
  #       locals: { draft: draft, context: context, draft_chat_messages: chat_messages, filter_params: {}, cube_cards: cube_cards }
  #     )
  #   end
  # end
end
