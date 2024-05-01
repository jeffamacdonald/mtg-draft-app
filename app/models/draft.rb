# t.references :cube, references: :cubes, foreign_key: { to_table: :cubes }
# t.references :user, references: :users, foreign_key: { to_table: :users }
# t.string :name, null: false
# t.integer :rounds, null: false
# t.integer :timer_minutes
# t.string :status, null: false
# t.timestamps null: false

class Draft < ApplicationRecord
  belongs_to :cube
  belongs_to :owner, foreign_key: :user_id, class_name: "User"
  has_many :draft_participants
  has_many :users, :through => :draft_participants
  has_many :participant_picks, :through => :draft_participants
  enum :status, DraftStatus.all.zip(DraftStatus.all).to_h

  scope :pending, -> { where(status: DraftStatus.pending) }

  def create_participants(user_ids)
    existing_user_ids = draft_participants.map(&:user_id)
    users = User.find(user_ids.reject{|id| existing_user_ids.include? id})
    draft_participant_hashes = users.map do |user|
      {
        :draft_id => id,
        :user_id => user.id,
        :display_name => user.username,
        :created_at => Time.now,
        :updated_at => Time.now
      }
    end
    DraftParticipant.insert_all(draft_participant_hashes)
  end

  def set_participant_positions
    draft_participants.shuffle.each.with_index do |participant, i|
      participant.update(draft_position: i + 1)
    end
  end

  def display_draft
    self.attributes.merge({
      :active_participant => self.active_participant
    })
  end

  def display_card_pool
    cube.display_cube.map { |k,v|
      [k,v.map do |card|
        card.attributes.merge({:is_drafted => participant_picks.find_by(cube_card_id: card.id).present? })
      end]
    }.to_h
  end

  # TODO: round is not here
  # def active_participant_new
  #   last_pick = participant_picks.maximum(:pick_number).to_i
  #   ordered_participants.where(skipped: false).joins(:participant_picks).find_by("participant_picks.pick_number <= ?", last_pick - (round * draft_participants.count))
  # end

  def active_participant(skipped = 0)
    last_pick = participant_picks.maximum(:pick_number).to_i + skipped
    if last_pick == 0
      return draft_participants.find_by(draft_position: 1)
    end
    draft_participants.find do |drafter|
      if drafter.next_pick_number == last_pick + 1
        if drafter.skipped?
          active_drafter = active_participant(skipped + 1)
        else
          active_drafter = drafter
        end
        break active_drafter
      end
    end
  end

  private

  def ordered_participants
    if round.odd?
      draft_participants.ordered
    else
      draft_participants.reversed
    end
  end
end
