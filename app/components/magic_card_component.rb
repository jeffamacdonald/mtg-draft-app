class MagicCardComponent < ViewComponent::Base
  attr_reader :cube_card, :context

  def initialize(cube_card:, context:)
    @cube_card = cube_card
    @context = context
  end

  def link_url
    context.link_url(cube_card)
  end
end
