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
end
