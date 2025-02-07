# frozen_string_literal: true

class DraftParticipantQueuedPicksComponent < ViewComponent::Base
  attr_reader :draft_participant

  def initialize(draft_participant:)
    @draft_participant = draft_participant
  end

  def render?
    draft_participant.queued_picks.present?
  end

  def context
    @_context ||= MagicCardContext.for_view_only
  end

  def border_color(index)
    return "border-warning border-3" if index == 0
    "border-dark"
  end
end