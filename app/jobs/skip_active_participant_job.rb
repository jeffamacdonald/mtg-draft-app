class SkipActiveParticipantJob < ApplicationJob
  queue_as :default

  def perform(participant_pick)
    draft = participant_pick.draft
    if draft.active_pick == participant_pick
      draft_participant = participant_pick.draft_participant
      draft_participant.update!(skipped: true)
      participant_pick.update!(skipped: true)
      draft.update!(last_pick_at: draft_participant.reload.updated_at)
      unless draft_participant == draft.reload.active_participant
        PickMailer.skipped_email(draft_participant, draft.reload.active_participant.user).deliver_now
      end
      Broadcast::DraftUpdateJob.perform_later(draft)

      # Enqueue next skip
      draft.enqueue_skip_job
    end
  end
end
