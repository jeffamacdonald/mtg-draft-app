FactoryBot.define do
  factory :cube do
    transient do
      user { create :user }
    end
    user_id { user.id }
    name { "factory cube" }

    trait :with_cube_cards do
      after(:create) do |cube, evaluator|
        10.times do
          create(:cube_card, cube: cube)
        end
      end
    end
  end
end
