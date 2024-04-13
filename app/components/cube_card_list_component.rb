class CubeCardListComponent < ViewComponent::Base
  attr_reader :cube

  def initialize(cube:)
    @cube = cube
  end

  def cube_sections
    Cube::Display.new(cube).sections
  end
end
