# frozen_string_literal: true

class DisplayCardComponent < ViewComponent::Base
  attr_reader :width

  WIDTHS = {
    sm: "col-md-4",
    md: "col-md-6",
    lg: "col-md-8",
    xl: "col flex-fill"
  }.freeze

  def initialize(width: :sm)
    @width = WIDTHS.fetch(width)
  end
end
