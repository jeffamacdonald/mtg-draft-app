FactoryBot.define do
  factory :draft do
    cube { create :cube }
    user { create :user }
    sequence(:name) { |n| "draft#{n}" }
    status { 'PENDING' }
    rounds { 40 }
    timer_minutes { 120 }
  end
end
