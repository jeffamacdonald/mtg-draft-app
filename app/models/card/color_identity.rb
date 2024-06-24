class Card
  class ColorIdentity
    COLOR_IDENTITIES = {
      "L" => "land",
      "C" => "colorless",
      "W" => "white",
      "U" => "blue",
      "B" => "black",
      "R" => "red",
      "G" => "green"
    }

    attr_reader :color_identities

    def initialize(color_identities)
      @color_identities = color_identities.sort
    end

    def display_identity
      color_identities.map do |identity|
        COLOR_IDENTITIES[identity]
      end.join(" ")
    end

    def background_class
      if colorless?
        "bg-gray"
      elsif land?
        "bg-peach"
      elsif color_identities.count > 1
        "bg-gold"
      else
        "bg-#{COLOR_IDENTITIES[color_identities.first]}"
      end
    end

    def text_class
      if background_class == "bg-black"
        "text-white"
      end
    end

    def land?
      color_identities == ["L"]
    end

    def colorless?
      color_identities == ["C"]
    end

    def white?
      color_identities.include? "W"
    end

    def blue?
      color_identities.include? "U"
    end

    def black?
      color_identities.include? "B"
    end

    def red?
      color_identities.include? "R"
    end

    def green?
      color_identities.include? "G"
    end
  end
end
