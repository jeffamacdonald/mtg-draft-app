class PickListComponent < ViewComponent::Base
  attr_reader :draft, :context

  def initialize(draft:, context:)
    @draft = draft
    @context = context
  end

  def pick_for_round_and_participant(round, participant)
    pick = participant.participant_picks.for_round(round).first
    if pick.blank? && participant.skipped? && round_of_last_pick >= round
      pick = SkippedPick.new
    end
    pick
  end

  def round_of_last_pick
    draft.participant_picks.ordered.pluck(&:round).last
  end

  def active_participant_class(participant)
    if context.active_participant == participant
      "bg-success"
    end
  end
end
