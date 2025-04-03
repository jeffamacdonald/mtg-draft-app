# == Schema Information
#
# Table name: cards
#
#  id             :uuid             not null, primary key
#  card_text      :string
#  cmc            :integer          not null
#  color_identity :string           not null, is an Array
#  cost           :string
#  default_image  :string           not null
#  default_set    :string           not null
#  layout         :string
#  name           :string           not null
#  power          :integer
#  scryfall_uri   :string
#  toughness      :integer
#  type_line      :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_cards_on_card_text       (card_text)
#  index_cards_on_cmc             (cmc)
#  index_cards_on_color_identity  (color_identity)
#  index_cards_on_name            (name) UNIQUE
#  index_cards_on_power           (power)
#  index_cards_on_toughness       (toughness)
#
FactoryBot.define do
  factory :card do
    sequence(:name) { |n| "Card_#{n}" }
    cost {"0"}
    cmc {0}
    card_text {"{T}, Sacrifice Black Lotus: Add three mana of any one color."}
    layout {"normal"}
    default_image {"https://cards.scryfall.io/large/front/6/6/66b875b1-e534-4ed8-9ebd-8f4d5a066e7d.jpg?1613677449"}
    color_identity {["C"]}
    default_set {"LEB"}
    type_line {"Artifact"}
  end
end
