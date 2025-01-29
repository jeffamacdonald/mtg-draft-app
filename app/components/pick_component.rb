class PickComponent < ViewComponent::Base
  attr_reader :participant_pick

  def initialize(participant_pick)
    @participant_pick = participant_pick
  end

  def pick_classes
    "#{pick_bg_class} #{pick_text_class}"
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
end