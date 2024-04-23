FactoryBot.define do
  factory :cube_card do
    transient do
      color_identity { ["W"] }
      cube { create :cube }
      card { create :card, color_identity: color_identity }
    end
    cube_id { cube.id }
    card_id { card.id }
    custom_color_identity { color_identity }
    custom_cmc { card.cmc }
    custom_image { card.default_image }
    custom_set { card.default_set }
    count {1}
    soft_delete {false}
  end
end
