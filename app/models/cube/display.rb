class Cube
  class Display
    attr_reader :cube_cards

    class Section < Struct.new(:title, :cards, keyword_init: true);end

    SINGLE_COLOR_SECTIONS = %w[white blue black red green].freeze

    BASIC_LANDS = { "W" => "Plains", "U" => "Island", "B" => "Swamp", "R" => "Mountain", "G" => "Forest" }.freeze
    TRI_LAND_MIN_BASIC_TYPES = 3
    COLOR_PAIRS = %w[WU WB WR WG UB UR UG BR BG RG].map(&:chars).freeze

    # Checked in order against (type_line, rules text); a match sorts the land earlier.
    LAND_SORT_RULES = [
      # Tri-lands and other lands with 3+ basic land types
      ->(type_line, _) { (type_line.split(" ") & BASIC_LANDS.values).size >= TRI_LAND_MIN_BASIC_TYPES },
      *COLOR_PAIRS.flat_map do |a, b|
        [
          # Two-color duals, by mana symbols in the text
          ->(_, text) { text.include?("{#{a}}") && text.include?("{#{b}}") },
          # Duals and fetch lands that name both basic land types (Flooded Strand)
          ->(_, text) { text.include?(BASIC_LANDS[a]) && text.include?(BASIC_LANDS[b]) }
        ]
      end,
      # Lands that make any color (City of Brass, Command Tower)
      ->(_, text) { text.include?("any color") },
      # Lands that copy what you could produce (Reflecting Pool)
      ->(_, text) { text.include?("any type") },
      # Basic-land fetchers (Evolving Wilds)
      ->(_, text) { text.include?("basic land card") },
      # Colorless utility lands
      ->(_, text) { text.include?("Add {C}") },
      # Mono-colored lands, in WUBRG order
      *BASIC_LANDS.map { |color, basic| ->(_, text) { text.include?("{#{color}}") || text.include?(basic) } }
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

    # Lands sort by the first rule they satisfy, in LAND_SORT_RULES order.
    def sort_land(cube_cards)
      cube_cards&.sort_by { |cube_card| land_sort_key(cube_card) }
    end

    def land_sort_key(cube_card)
      type_line = cube_card.type_line.to_s
      text = cube_card.card_text.to_s
      LAND_SORT_RULES.map { |rule| rule.call(type_line, text) ? 0 : 1 }
    end
  end
end
