class CubeCardListSectionComponent < ViewComponent::Base
  attr_reader :cube_section

  delegate :title, :cards, to: :cube_section

  def initialize(cube_section:)
    @cube_section = cube_section
  end
end
