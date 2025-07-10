class PickNextQueuedPickJob < ApplicationJob
  queue_as :default

  def perform(participant_pick)
    draft_participant = participant_pick.draft_participant
    draft = draft_participant.draft
    if draft.active_pick == participant_pick && draft_participant.queue_active? && draft_participant.queued_picks.present?
      pick = draft_participant.pick_card!(draft_participant.queued_picks.find_by(priority_number: 1).cube_card)

      # Email next participant
      next_user = draft_participant.reload.draft.active_participant.user
      if next_user != draft_participant.user
        PickMailer.next_up_email(pick, next_user).deliver_now
      end
    end
  end
end