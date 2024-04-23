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

  def self.create_card_from_hash(card_hash)
    color_identity = if card_hash[:type_line].include? "Land"
      ['L']
    elsif card_hash[:color_identity].empty?
      ['C']
    else
      card_hash[:color_identity]
    end
    Card.create! do |card|
      card.name = card_hash[:name]
      card.cost = card_hash[:mana_cost]
      card.cmc = card_hash[:cmc]
      card.card_text = card_hash[:oracle_text]
      card.layout = card_hash[:layout]
      card.power = card_hash[:power]
      card.toughness = card_hash[:toughness]
      card.default_image = card_hash[:image_uri]
      card.color_identity = color_identity
      card.default_set = card_hash[:set]
      card.type_line = card_hash[:type_line]
    end
  end

  delegate :land?, :colorless?, :white?, :blue?, :black?, :red?, :green?, to: :color_identity

  def color_identity
    Card::ColorIdentity.new(super)
  end
end
