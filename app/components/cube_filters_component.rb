# frozen_string_literal: true

class CubeFiltersComponent < ViewComponent::Base
  attr_reader :url, :filter_params

  TEXT_FIELDS = [ [ "Name", "name" ], [ "Card text", "o" ], [ "Type", "t" ], [ "Set", "s" ] ].freeze
  COLOR_FIELDS = [ [ "Color", "c" ], [ "Color identity", "ci" ] ].freeze
  NUMBER_FIELDS = [ [ "Mana value", "mv" ], [ "Power", "pow" ], [ "Toughness", "tou" ], [ "Power + toughness", "pt" ] ].freeze
  COLOR_OPERATORS = [ [ "includes", ">=" ], [ "exactly", "=" ], [ "no more than", "<=" ], [ "more than", ">" ], [ "fewer than", "<" ], [ "not", "!=" ] ].freeze
  NUMBER_OPERATORS = [ [ "=", "=" ], [ "<", "<" ], [ "<=", "<=" ], [ ">", ">" ], [ ">=", ">=" ], [ "!=", "!=" ] ].freeze
  MANA_OPERATORS = [ [ "at least", ":" ], [ "exactly", "=" ], [ "more than", ">" ], [ "not", "!=" ] ].freeze
  LAYOUTS = %w[normal split flip transform modal_dfc meld leveler saga adventure].freeze
  IS_KEYWORDS = %w[gold hybrid phyrexian twobrid permanent spell dfc].freeze

  def initialize(url:, filter_params:)
    @url = url
    @filter_params = filter_params
  end
end
