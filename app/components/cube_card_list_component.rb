class CubeCardListComponent < ViewComponent::Base
  attr_reader :cube_cards, :context

  def initialize(cube_cards:, context:)
    @cube_cards = cube_cards
    @context = context
  end

  def cube_sections
    Cube::Display.new(cube_cards).sections
  end
end
