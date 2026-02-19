# == Schema Information
#
# Table name: cube_cards
#
#  id                    :uuid             not null, primary key
#  count                 :integer          not null
#  custom_cmc            :integer          not null
#  custom_color_identity :string           not null, is an Array
#  custom_image          :string           not null
#  custom_set            :string           not null
#  soft_delete           :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  card_id               :uuid
#  cube_id               :uuid
#
# Indexes
#
#  index_cube_cards_on_card_id                (card_id)
#  index_cube_cards_on_cube_id                (cube_id)
#  index_cube_cards_on_cube_soft_delete_cmc   (cube_id,soft_delete,custom_cmc)
#  index_cube_cards_on_custom_color_identity  (custom_color_identity)
#  index_cube_cards_on_soft_delete            (soft_delete)
#
# Foreign Keys
#
#  fk_rails_...  (card_id => cards.id)
#  fk_rails_...  (cube_id => cubes.id)
#
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
