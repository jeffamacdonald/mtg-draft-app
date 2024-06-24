# t.string :name, null: false
# t.string :cost
# t.integer :cmc, null: false
# t.string :color_identity, array: true, null: false
# t.string :type_line, null: false
# t.string :card_text
# t.string :layout
# t.integer :power
# t.integer :toughness
# t.string :default_image, null: false
# t.string :default_set, null: false
# t.timestamps null: false

class Card < ApplicationRecord
  has_many :cube_cards
  has_many :cubes, :through => :cube_cards

  scope :with_names, ->(card_names) { where(name: card_names) }

  delegate :land?, :colorless?, :white?, :blue?, :black?, :red?, :green?, to: :color_identity

  def color_identity
    Card::ColorIdentity.new(super)
  end
end
