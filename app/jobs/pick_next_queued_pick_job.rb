class PickNextQueuedPickJob < ApplicationJob
  queue_as :default

  def perform(participant_pick)
    draft_participant = participant_pick.draft_participant
    draft = draft_participant.draft
    if draft.active_pick == participant_pick && draft_participant.queue_active? && draft_participant.queued_picks.present?
      cube_card = draft_participant.queued_picks.find_by(priority_number: 1).cube_card
      pick = Drafts::MakePick.call(draft_participant:, cube_card:, participant_pick_id: participant_pick.id)

      Drafts::NotifyNextUp.call(pick:, except_user: draft_participant.user)
    end
  rescue Drafts::MakePick::StalePick
    # The pick was made by hand after the check above, so there is nothing to auto-pick
  end
end
