class CubeCardListSectionComponent < ViewComponent::Base
  attr_reader :title, :cube_cards

  def initialize(title:, cube_cards:)
    @title = title
    @cube_cards = cube_cards
  end
end
