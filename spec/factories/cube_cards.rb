FactoryBot.define do
  factory :cube_card do
    transient do
      cube { create :cube }
      card { create :card }
    end
    cube_id { cube.id }
    card_id { card.id }
    count {1}
    soft_delete {false}

    trait :with_color_identity do
      transient do
        color_identity { ["W"] }
        card { create :card, color_identity: color_identity }
      end
    end
  end
end
