# == Schema Information
#
# Table name: queued_picks
#
#  id                   :uuid             not null, primary key
#  priority_number      :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cube_card_id         :uuid
#  draft_participant_id :uuid
#
# Indexes
#
#  index_queued_picks_on_cube_card_id          (cube_card_id)
#  index_queued_picks_on_draft_participant_id  (draft_participant_id)
#
# Foreign Keys
#
#  fk_rails_...  (cube_card_id => cube_cards.id)
#  fk_rails_...  (draft_participant_id => draft_participants.id)
#
class QueuedPick < ApplicationRecord
  belongs_to :draft_participant
  belongs_to :cube_card

  def handle_cube_card_picked!
    ActiveRecord::Base.transaction do
      lower_priority_picks = draft_participant.queued_picks.where("priority_number > ?", priority_number).order(:priority_number)
      lower_priority_picks.each do |qp|
        qp.update!(priority_number: qp.priority_number - 1)
      end
      self.destroy!
    end
  end
end
