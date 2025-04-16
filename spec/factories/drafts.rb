# == Schema Information
#
# Table name: drafts
#
#  id                :uuid             not null, primary key
#  last_pick_at      :datetime
#  name              :string           not null
#  rounds            :integer          not null
#  status            :string           not null
#  timer_minutes     :integer
#  transfers_allowed :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cube_id           :uuid
#  user_id           :uuid
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
FactoryBot.define do
  factory :draft do
    cube { create :cube }
    owner { create :user }
    sequence(:name) { |n| "draft#{n}" }
    status { DraftStatus.pending }
    rounds { 40 }
    timer_minutes { 120 }
  end
end
