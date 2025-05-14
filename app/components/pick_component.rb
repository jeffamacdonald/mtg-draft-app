class PickComponent < ViewComponent::Base
  attr_reader :participant_pick

  def initialize(participant_pick)
    @participant_pick = participant_pick
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

  def pick_bg_class
    return Card::SkippedColorIdentity.new.background_class if participant_pick.skipped?
    return if participant_pick.cube_card.blank?

    participant_pick.color_identity.background_class
  end

  def pick_text_class
    return if participant_pick.cube_card.blank?

    participant_pick.color_identity.text_class
  end

  def highlighted_class
    return unless participant_pick.transfered?

    "highlighted-pick"
  end
end