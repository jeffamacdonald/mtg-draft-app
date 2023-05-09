class MagicCardComponent < ViewComponent::Base
  attr_reader :cube_card

  def initialize(cube_card:)
    @cube_card = cube_card
  end
end
