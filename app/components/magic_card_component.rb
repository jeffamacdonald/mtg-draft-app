class MagicCardComponent < ViewComponent::Base
  attr_reader :cube_card, :context

  def initialize(cube_card:, context:)
    @cube_card = cube_card
    @context = context
  end

  def link_url
    context.link_url(cube_card)
  end

  def size_class
    return unless context.image_size.present?

    if context.image_size == "lg"
      "col-md col-6"
    else
      "col-md col-3"
    end
  end

  def css_class
    if context.picked?(cube_card)
      "cube_card__img__picked"
    else
      "cube_card__img"
    end
  end

  def text_only_class
    if context.picked?(cube_card)
      "text-decoration-line-through"
    else
      ""
    end
  end

  def show_link?
    link_url.present? && !context.picked?(cube_card)
  end
end
