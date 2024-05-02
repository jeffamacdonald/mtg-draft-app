FactoryBot.define do
  factory :draft do
    cube { create :cube }
    owner { create :user }
    sequence(:name) { |n| "draft#{n}" }
    status { DraftStatus.pending }
    rounds { 40 }
    timer_minutes { 120 }
    active_round { 1 }
  end
end
