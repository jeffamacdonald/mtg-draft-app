class RemoveQueuedPicksJob < ApplicationJob
  queue_as :default

  def perform(participant_pick)
    draft = participant_pick.draft
    cube_card = participant_pick.cube_card
    queued_picks = QueuedPick.joins(draft_participant: :draft).where(draft: { id: draft.id }, cube_card: cube_card).all
    queued_picks.each do |queued_pick|
      if participant_pick.draft_participant != queued_pick.draft_participant && queued_pick.priority_number == 1 && queued_pick.draft_participant.queue_active?
        queued_pick.draft_participant.update!(queue_active: false)
        PickMailer.queued_pick_taken_email(participant_pick, queued_pick.draft_participant.user).deliver_now
      end
      queued_pick.handle_cube_card_picked!
    end
  end
end