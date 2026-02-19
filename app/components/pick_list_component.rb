class PickListComponent < ViewComponent::Base
  attr_reader :draft, :context, :font_size

  def initialize(draft:, context:)
    @draft = draft
    @context = context
    @font_size = context.draft_participant&.user&.pick_list_size || ""
  end

  def active_participant_class(participant)
    if context.active_participant == participant
      "bg-cyan"
    end
  end

  def grouped_picks_by_round
    # Use already loaded participant_picks to avoid additional queries
    @grouped_picks_by_round ||= draft.participant_picks
      .sort_by(&:pick_number)
      .group_by(&:round)
  end

  def ordered_participants
    @ordered_participants ||= draft.draft_participants.sort_by(&:draft_position)
  end
end
