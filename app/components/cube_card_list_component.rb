class CubeCardListComponent < ViewComponent::Base
  attr_reader :cube_cards

  def initialize(cube_cards:)
    @cube_cards = cube_cards
  end

  def cube_sections
    Cube::Display.new(cube_cards).sections
  end
end
