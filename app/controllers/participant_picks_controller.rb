class ParticipantPicksController < ApplicationController
  def new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    @cube_card = CubeCard.find(params[:cube_card_id])
  end

  def create
    draft_participant = DraftParticipant.find(create_params[:draft_participant_id])
    cube_card = CubeCard.find(create_params[:cube_card_id])
    draft_participant.pick_card!(cube_card)

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
