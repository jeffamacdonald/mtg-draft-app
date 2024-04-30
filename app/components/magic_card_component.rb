class MagicCardComponent < ViewComponent::Base
  attr_reader :cube_card, :context

  def initialize(cube_card:, context:)
    @cube_card = cube_card
    @context = context
  end

  def link_url
    if context.is_a?(Cube)
      edit_cube_card_path(@cube_card)
    else

    end
  end
end
