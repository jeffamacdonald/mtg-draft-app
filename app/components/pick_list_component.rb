class PickListComponent < ViewComponent::Base
  attr_reader :draft, :context

  def initialize(draft:, context:)
    @draft = draft
    @context = context
  end

  def pick_for_round_and_participant(round, participant)
    pick = participant.participant_picks.for_round(round).first
    if pick.blank? && participant.skipped?
      pick = SkippedPick.new
    end
    pick
  end

  def active_participant_class(participant)
    if context.active_participant == participant
      "bg-cyan"
    end
  end

  def pick_classes(pick)
    "#{pick_bg_class(pick)} #{pick_text_class(pick)}"
  end

  private

  def pick_bg_class(pick)
    return if pick.blank?

    pick.color_identity.background_class
  end

  def pick_text_class(pick)
    return if pick.blank?

    pick.color_identity.text_class
  end
end
