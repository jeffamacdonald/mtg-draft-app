# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  base_button_classes = "btn btn-block btn:hover"

  VARIATIONS = {
    primary: "#{base_button_classes} btn-primary",
    secondary: "#{base_button_classes} btn-secondary",
    light: "#{base_button_classes} btn-light",
    dark: "#{base_button_classes} btn-dark",
    link: "#{base_button_classes} btn-link"
  }.freeze
  VARIATION_OPTIONS = VARIATIONS.keys

  SIZES = {
    sm: "btn-sm",
    md: "",
    lg: "btn-lg"
  }.freeze
  SIZE_OPTIONS = SIZES.keys

  def initialize(url: nil, variation: :primary, size: :md, classes: "", **kargs)
    @url = url
    @variation = variation ? VARIATIONS.fetch(variation) : ""
    @size = size ? SIZES.fetch(size) : ""
    @classes = "#{classes} #{@variation} #{@size}"
    @attributes = kargs
  end
end
