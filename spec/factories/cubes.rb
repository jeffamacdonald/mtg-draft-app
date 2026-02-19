# == Schema Information
#
# Table name: cubes
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_cubes_on_name     (name)
#  index_cubes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :cube do
    association :owner, factory: :user
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
