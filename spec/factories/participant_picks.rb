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
#  index_participant_picks_on_cube_card_id          (cube_card_id)
#  index_participant_picks_on_draft_participant_id  (draft_participant_id)
#  index_participant_picks_on_round                 (round)
#
# Foreign Keys
#
#  fk_rails_...  (cube_card_id => cube_cards.id)
#  fk_rails_...  (draft_participant_id => draft_participants.id)
#
FactoryBot.define do
  factory :participant_pick do
    transient do
      draft_participant { create :draft_participant }
      cube_card { create :cube_card }
    end
    draft_participant_id { draft_participant.id }
    cube_card_id { cube_card.id }
    sequence(:pick_number) { |n| n }
    round { 1 }
  end
end
