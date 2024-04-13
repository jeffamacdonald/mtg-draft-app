class Card
  class ColorIdentity
    COLOR_IDENTITIES = {
      "C" => "colorless",
      "W" => "white",
      "U" => "blue",
      "B" => "black",
      "R" => "red",
      "G" => "green"
    }

    attr_reader :card_identities

    def initialize(card_identities)
      @card_identities = card_identities.sort
    end

    def display_identity
      card_identities.map do |identity|
        COLOR_IDENTITIES[identity]
      end.join(" ")
    end

    def colorless?
      card_identities == ["C"]
    end

    def white?
      card_identities.include? "W"
    end

    def blue?
      card_identities.include? "U"
    end

    def black?
      card_identities.include? "B"
    end

    def red?
      card_identities.include? "R"
    end

    def green?
      card_identities.include? "G"
    end
  end
end
