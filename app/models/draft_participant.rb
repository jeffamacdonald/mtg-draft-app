# == Schema Information
#
# Table name: draft_participants
#
#  id                 :uuid             not null, primary key
#  display_color      :string
#  display_name       :string           not null
#  draft_position     :integer
#  queue_active       :boolean          default(FALSE), not null
#  queue_minute_delay :integer          default(0), not null
#  skipped            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  draft_id           :uuid
#  surrogate_user_id  :uuid
#  user_id            :uuid
#
# Indexes
#
#  index_draft_participants_on_draft_id                     (draft_id)
#  index_draft_participants_on_draft_id_and_draft_position  (draft_id,draft_position) UNIQUE
#  index_draft_participants_on_draft_id_and_user_id         (draft_id,user_id) UNIQUE
#  index_draft_participants_on_surrogate_user_id            (surrogate_user_id)
#  index_draft_participants_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (draft_id => drafts.id)
#  fk_rails_...  (surrogate_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class DraftParticipant < ApplicationRecord
  belongs_to :draft
  belongs_to :user
  has_many :participant_picks
  has_many :queued_picks
  has_many :cube_cards, :through => :participant_picks
  has_many :surrogate_draft_participants
  has_many :surrogate_participants, through: :surrogate_draft_participants

  scope :unskipped, -> { where(skipped: false) }
  scope :skipped, -> { where(skipped: true) }
  scope :ordered, -> { order(:draft_position) }
  scope :reversed, -> { order(draft_position: :desc) } 
   
  DISPLAY_COLORS = %w[#e6194b #3cb44b #ffe338 #4363d8 #f58231 #911eb4 #46f0f0 #f032e6 #bcf60c #fabebe #008080 #e6beff #9a6324 #a58559 #800000 #76dbaa #808000 #ffd8b1 #000075 #808080]
  
  def set_display_color!
    color = (DISPLAY_COLORS - draft.draft_participants.map(&:display_color)).sample
    update!(display_color: color)
  end

  def pick_card!(cube_card)
    round = next_pick_round
    pick = ParticipantPick.find_by(draft_participant: self,
      round: round)
    pick.update!(cube_card: cube_card, skipped: false)
    if skipped?
      if draft.last_pick_number < next_pick_number
        update!(skipped: false)
      end
    else
      draft.update!(last_pick_at: pick.updated_at)
      if pick.pick_number == draft.draft_participants.count * draft.rounds
        draft.completed!
      else
        draft.enqueue_skip_job
        draft.active_pick.enqueue_auto_pick_job
      end
    end
    
    RemoveQueuedPicksJob.perform_later(pick)
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
    participant_picks.reload.where.not(cube_card_id: nil).order(:pick_number).last
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

  def calculate_pick_number(round)
    total_drafters = draft.draft_participants.count
    if round % 2 == 1
      ((round-1) * total_drafters + draft_position)
    else
      round * total_drafters - draft_position + 1
    end
  end

  private

  def next_pick_round
    last_pick.nil? ? 1 : last_pick.round + 1
  end
end
