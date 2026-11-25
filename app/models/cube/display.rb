class Cube
  class Display
    attr_reader :cube_cards

    class Section < Struct.new(:title, :cards, keyword_init: true);end

    SINGLE_COLOR_SECTIONS = %w[white blue black red green].freeze

    BASIC_LANDS = { "W" => "Plains", "U" => "Island", "B" => "Swamp", "R" => "Mountain", "G" => "Forest" }.freeze
    COLOR_PAIRS = %w[WU WB WR WG UB UR UG BR BG RG].map(&:chars).freeze

    # Checked in order against a land's rules text; a match sorts the land earlier.
    LAND_TEXT_RULES = [
      *COLOR_PAIRS.flat_map do |a, b|
        [
          ->(text) { text.include?("{#{a}}") && text.include?("{#{b}}") },
          ->(text) { text.include?(BASIC_LANDS[a]) && text.include?(BASIC_LANDS[b]) }
        ]
      end,
      ->(text) { text.include?("any color") },
      ->(text) { text.include?("any type") },
      ->(text) { text.include?("basic land card") },
      ->(text) { text.include?("Add {C}") },
      *BASIC_LANDS.map { |color, basic| ->(text) { text.include?("{#{color}}") || text.include?(basic) } }
    ].freeze

    def initialize(cube_cards)
      @cube_cards = cube_cards
    end

    def sections
      [ *SINGLE_COLOR_SECTIONS.map { |color| section_for(color) }, gold, section_for("colorless"), section_for("land") ].compact
    end

    private

    def to_hash
      @_to_hash ||= cube_cards.each_with_object({}) do |cube_card, hsh|
        (hsh[cube_card.color_identity.display_identity] ||= []) << cube_card
      end
    end

    def section_for(color)
      cards = to_hash[color]
      return if cards.blank?

      Section.new(title: color.titleize, cards: color == "land" ? sort_land(cards) : cards)
    end

    def gold
      cards = two_color_gold + many_color_gold
      return if cards.blank?

      Section.new(title: "Gold", cards: cards)
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

    # Lands sort by the first rule they satisfy: type-heavy lands, then each color pair
    # (dual mana symbols, then both basic land types), then any-color / any-type / fetch /
    # colorless lands, then single-color lands in WUBRG order.
    def sort_land(cube_cards)
      cube_cards&.sort_by { |cube_card| land_sort_key(cube_card) }
    end

    def land_sort_key(cube_card)
      words = cube_card.type_line.to_s.split(" ")
      text = cube_card.card_text.to_s
      [ words.first == "Land" && words.count > 4 ? 0 : 1, *LAND_TEXT_RULES.map { |rule| rule.call(text) ? 0 : 1 } ]
    end
  end
end
