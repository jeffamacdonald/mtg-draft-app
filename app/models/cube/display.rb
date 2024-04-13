class Cube
  class Display
    attr_reader :cube

    class Section < Struct.new(:title, :cards, keyword_init: true);end

    def initialize(cube)
      @cube = cube
    end

    def sections
      [white, blue, black, red, green, gold, land]
    end

    private

    def to_hash
      cube.cube_cards.active.sorted.chunk_while do |bef, aft|
        bef.color_identity.display_identity == aft.color_identity.display_identity
      end.each_with_object({}) do |chnk, hsh|
        hsh[chnk.first.color_identity.display_identity] = chnk
      end
    end

    Card::ColorIdentity::COLOR_IDENTITIES.values.each do |color|
      define_method(color.to_sym) do
        Section.new(title: color.titleize, cards: to_hash[color])
      end
    end

    def gold
      Section.new(title: "Gold", cards: two_color_gold + many_color_gold)
    end

    def two_color_gold
      to_hash.select do |color, cards|
        cards.first.color_identity.card_identities.count == 2
      end.values.flatten
    end

    def many_color_gold
      to_hash.select do |color, cards|
        cards.first.color_identity.card_identities.count > 2
      end.values.flatten
    end
  end
end
