class ParticipantPicksController < ApplicationController
  def new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    @cube_card = CubeCard.find(params[:cube_card_id])
  end

  def create
    draft_participant = DraftParticipant.find(create_params[:draft_participant_id])
    cube_card = CubeCard.find(create_params[:cube_card_id])
    pick = draft_participant.pick_card!(cube_card)

    draft = draft_participant.reload.draft

    # Refresh all browsers
    DraftChannel.broadcast_to(draft, {})
    # Email next participant
    new_active_participant = draft.active_participant
    if new_active_participant.user != current_user
      PickMailer.next_up_email(pick, new_active_participant.user).deliver_now
    end

    redirect_to draft_path(draft_participant.draft)
  end

  private

  def create_params
    params.require(:participant_pick).permit(
      :cube_card_id,
      :draft_participant_id
    )
  end
end
