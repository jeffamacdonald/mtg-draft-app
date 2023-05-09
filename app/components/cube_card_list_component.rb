class CubeCardListComponent < ViewComponent::Base
  attr_reader :cube

  def initialize(cube:)
    @cube = cube
  end
end
