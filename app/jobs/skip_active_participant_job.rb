class SkipActiveParticipantJob < ApplicationJob
  queue_as :default

  def perform(draft, draft_participant, last_pick_number)
    if draft.active_participant.id == draft_participant.id && draft.last_pick_number == last_pick_number
      # Increment active round if skipping the last pick in a round
      if draft_participant.edge_case? && draft_participant.last_pick.pick_number != draft.last_pick_number
        draft.update!(active_round: [draft.active_round + 1, draft.rounds].min)
      end
      draft_participant.update!(skipped: true)
      draft.update!(last_pick_at: draft_participant.reload.updated_at)

      new_active_participant = draft.reload.active_participant
      PickMailer.skipped_email(draft_participant, new_active_participant.user).deliver_now
      # Refresh all browsers
      DraftChannel.broadcast_to(draft, {})

      # Enqueue next skip
      draft.enqueue_skip_job(new_active_participant)
    end
  end
end
