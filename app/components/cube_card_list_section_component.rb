class CubeCardListSectionComponent < ViewComponent::Base
  attr_reader :cube_section, :context

  delegate :title, :cards, to: :cube_section

  def initialize(cube_section:, context:)
    @cube_section = cube_section
    @context = context
  end

  def css_class
    if context.text_only?
      "flex-sm-row flex-column"
    else
      "flex-row"
    end
  end

  def size_class
    if context.image_size == "lg"
      "col-md col-6"
    else
      "col-md col-3"
    end
  end

  def row_size
    if context.image_size == "sm"
      8
    else
      6
    end
  end
end
