class Cube
  class Display
    attr_reader :cube

    class Section < Struct.new(:title, :cards, keyword_init: true);end

    def initialize(cube)
      @cube = cube
    end

    def sections
      [white, blue, black, red, green, gold, colorless, land]
    end

    private

    def to_hash
      @_to_hash ||= cube.cube_cards.active.sorted.each_with_object({}) do |cube_card, hsh|
        hsh[cube_card.color_identity.display_identity] ||= []
        hsh[cube_card.color_identity.display_identity] << cube_card
      end
    end

    Card::ColorIdentity::COLOR_IDENTITIES.values.each do |color|
      if color == "land"
        define_method(color.to_sym) do
          Section.new(title: color.titleize, cards: sort_land(to_hash[color]))
        end
      else
        define_method(color.to_sym) do
          Section.new(title: color.titleize, cards: to_hash[color])
        end
      end
    end

    def gold
      Section.new(title: "Gold", cards: two_color_gold + many_color_gold)
    end

    def two_color_gold
      to_hash.select do |color, cards|
        cards.first.color_identity.color_identities.count == 2
      end.values.flatten
    end

    def many_color_gold
      to_hash.select do |color, cards|
        cards.first.color_identity.color_identities.count > 2
      end.values.flatten
    end

    def sort_land(cube_cards)
      cube_cards.sort_by do |cube_card|
        [cube_card.card_text.include?("{W}") && cube_card.card_text.include?("{U}") ? 0 : 1,
        cube_card.card_text.include?("Plains") && cube_card.card_text.include?("Island") ? 0 : 1,
        cube_card.card_text.include?("{W}") && cube_card.card_text.include?("{B}") ? 0 : 1,
        cube_card.card_text.include?("Plains") && cube_card.card_text.include?("Swamp") ? 0 : 1,
        cube_card.card_text.include?("{W}") && cube_card.card_text.include?("{R}") ? 0 : 1,
        cube_card.card_text.include?("Plains") && cube_card.card_text.include?("Mountain") ? 0 : 1,
        cube_card.card_text.include?("{W}") && cube_card.card_text.include?("{G}") ? 0 : 1,
        cube_card.card_text.include?("Plains") && cube_card.card_text.include?("Forest") ? 0 : 1,
        cube_card.card_text.include?("{U}") && cube_card.card_text.include?("{B}") ? 0 : 1,
        cube_card.card_text.include?("Island") && cube_card.card_text.include?("Swamp") ? 0 : 1,
        cube_card.card_text.include?("{U}") && cube_card.card_text.include?("{R}") ? 0 : 1,
        cube_card.card_text.include?("Island") && cube_card.card_text.include?("Mountain") ? 0 : 1,
        cube_card.card_text.include?("{U}") && cube_card.card_text.include?("{G}") ? 0 : 1,
        cube_card.card_text.include?("Island") && cube_card.card_text.include?("Forest") ? 0 : 1,
        cube_card.card_text.include?("{B}") && cube_card.card_text.include?("{R}") ? 0 : 1,
        cube_card.card_text.include?("Swamp") && cube_card.card_text.include?("Mountain") ? 0 : 1,
        cube_card.card_text.include?("{B}") && cube_card.card_text.include?("{G}") ? 0 : 1,
        cube_card.card_text.include?("Swamp") && cube_card.card_text.include?("Forest") ? 0 : 1,
        cube_card.card_text.include?("{R}") && cube_card.card_text.include?("{G}") ? 0 : 1,
        cube_card.card_text.include?("Mountain") && cube_card.card_text.include?("Forest") ? 0 : 1,
        cube_card.card_text.include?("any color") ? 0 : 1,
        cube_card.card_text.include?("basic land card") ? 0 : 1,
        cube_card.card_text.include?("Add {C}") ? 0 : 1,
        cube_card.card_text.include?("{T}: Add") ? 0 : 1]
      end
    end
  end
end
