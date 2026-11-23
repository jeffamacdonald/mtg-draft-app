class PickComponent < ViewComponent::Base
  attr_reader :participant_pick

  def initialize(participant_pick)
    @participant_pick = participant_pick
  end

  def picked?
    grid_cube_card.present?
  end

  def card_name
    grid_cube_card&.name
  end

  def pick_classes
    "#{pick_bg_class} #{pick_text_class} #{highlighted_class}"
  end

  def hovercard_controller
    return unless participant_pick.transfered?

    "hovercard"
  end

  def hovercard_url
    return unless participant_pick.transfered?

    hovercard_participant_pick_path(participant_pick)
  end

  def hovercard_actions
    return unless participant_pick.transfered?

    "mouseenter->hovercard#show mouseleave->hovercard#hide"
  end

  private

  def grid_cube_card
    participant_pick.grid_cube_card
  end

  def pick_bg_class
    return Card::SkippedColorIdentity.new.background_class if participant_pick.skipped?
    return if grid_cube_card.blank?

    grid_cube_card.color_identity.background_class
  end

  def pick_text_class
    return if grid_cube_card.blank?

    grid_cube_card.color_identity.text_class
  end

  def highlighted_class
    return unless participant_pick.transfered?

    "highlighted-pick"
  end
end
