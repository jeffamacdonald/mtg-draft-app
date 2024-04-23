module Clients
  class ScryfallCard < Struct.new(:count, :name, :layout, :image_uri, :mana_cost, :cmc, :type_line, :oracle_text, :color_identity, :set, :power, :toughness, keyword_init: true)

    def create_card!
      Card.create!(
        name: name,
        cost: mana_cost,
        cmc: cmc,
        card_text: oracle_text,
        layout: layout,
        power: power,
        toughness: toughness,
        default_image: image_uri,
        color_identity: parse_color_identity,
        default_set: set,
        type_line: type_line
      )
    end

    def parse_color_identity
      if type_line.include? "Land"
        ['L']
      elsif color_identity.empty?
        ['C']
      else
        color_identity
      end
    end
  end
end
