# frozen_string_literal: true

class DisplayCardComponent < ViewComponent::Base
  attr_reader :classes, :container_class

  WIDTHS = {
    xs: "col-md-2",
    sm: "col-md-4",
    md: "col-md-6",
    lg: "col-md-8",
    xl: "col flex-fill",
    xxl: "col flex-fill"
  }.freeze

  CONTAINER_CLASSES = {
    xs: "container",
    sm: "container",
    md: "container",
    lg: "container",
    xl: "container",
    xxl: "container-fluid"
  }.freeze

  def initialize(width: :sm, classes: "")
    @classes = "#{WIDTHS.fetch(width)} #{classes}"
    @container_class = CONTAINER_CLASSES.fetch(width)
  end
end
