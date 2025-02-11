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
class Card < ApplicationRecord
  has_many :cube_cards
  has_many :cubes, :through => :cube_cards

  scope :with_names, ->(card_names) { where(name: card_names) }

  delegate :land?, :colorless?, :white?, :blue?, :black?, :red?, :green?, to: :color_identity

  def color_identity
    Card::ColorIdentity.new(super)
  end
end
