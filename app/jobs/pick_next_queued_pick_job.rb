class PickNextQueuedPickJob < ApplicationJob
  queue_as :default

  def perform(participant_pick)
    draft_participant = participant_pick.draft_participant
    draft = draft_participant.draft
    if draft.active_pick == participant_pick && draft_participant.queue_active? && draft_participant.queued_picks.present?
      draft_participant.pick_card!(draft_participant.queued_picks.find_by(priority_number: 1).cube_card)
    end
  end
end