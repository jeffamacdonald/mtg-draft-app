class CubeCardListSectionComponent < ViewComponent::Base
  attr_reader :cube_section, :context

  delegate :title, :cards, to: :cube_section

  def initialize(cube_section:, context:)
    @cube_section = cube_section
    @context = context
  end
end
