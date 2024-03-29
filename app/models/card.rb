# t.string :name, null: false
# t.string :cost
# t.integer :cmc, null: false
# t.string :color_identity, null: false
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

  COLOR_IDENTITIES = {
    land: "L",
    colorless: "C",
    white: "W",
    blue: "U",
    black: "B",
    red: "R",
    green: "G"
  }
  enum color_identity: COLOR_IDENTITIES

  def self.get_cards_by_cube_list(cube_list)
    where(name: cube_list.map { |c| c[:name] })
  end

  def self.create_card_from_hash(card_hash)
    Card.create! do |card|
      card.name = card_hash[:name]
      card.cost = card_hash[:mana_cost]
      card.cmc = card_hash[:cmc]
      card.card_text = card_hash[:oracle_text]
      card.layout = card_hash[:layout]
      card.power = card_hash[:power]
      card.toughness = card_hash[:toughness]
      card.default_image = card_hash[:image_uri]
      card.color_identity = get_color_identity(card_hash)
      card.default_set = card_hash[:set]
      card.type_line = card_hash[:type_line]
    end
  end

  def self.get_color_identity(card_hash)
    if card_hash[:color_identity].empty?
      'C'
    elsif card_hash[:type_line].include?('Land')
      'L'
    else
      card_hash[:color_identity].join
    end
  end
end
