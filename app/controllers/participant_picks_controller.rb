class ParticipantPicksController < ApplicationController
  def new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    @cube_card = CubeCard.find(params[:cube_card_id])
  end

  def create
    draft_participant = DraftParticipant.find(create_params[:draft_participant_id])
    cube_card = CubeCard.find(create_params[:cube_card_id])
    pick = draft_participant.pick_card!(cube_card)
    
    # Email next participant
    next_user = draft_participant.reload.draft.active_participant.user
    if next_user != current_user
      PickMailer.next_up_email(pick, next_user).deliver_now
    end

    redirect_to draft_path(draft_participant.draft)
  end

  def update
    @participant_pick = ParticipantPick.find(params[:id])
    @participant_pick.update!(update_params)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "participant_pick_#{@participant_pick.id}",
          render_to_string(PickComponent.new(@participant_pick))
        )
      end
    end

    Turbo::StreamsChannel.broadcast_replace_to(
      @participant_pick.draft,
      target: "participant_pick_#{@participant_pick.id}",
      partial: "drafts/pick",
      locals: { pick: @participant_pick }
    )
  end

  private

  def create_params
    params.require(:participant_pick).permit(
      :cube_card_id,
      :draft_participant_id
    )
  end

  def update_params
    params.require(:participant_pick).permit(:comment)
  end
end
