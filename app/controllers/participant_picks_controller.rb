class ParticipantPicksController < ApplicationController
  def new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    @cube_card = CubeCard.find(params[:cube_card_id])
  end

  def create
    draft_participant = DraftParticipant.find(create_params[:draft_participant_id])
    cube_card = CubeCard.find(create_params[:cube_card_id])
    pick = Drafts::MakePick.call(draft_participant:, cube_card:, participant_pick_id: create_params[:participant_pick_id])

    unless Drafts::NotifyNextUp.call(pick:, except_user: current_user)
      flash[:error] = "Your pick was saved, but the email to the next player failed to send. Please notify the admin."
    end

    redirect_to draft_path(draft_participant.draft)
  rescue Drafts::MakePick::StalePick
    flash[:error] = "That pick wasn't saved. It was already made, or your turn changed."
    redirect_to draft_path(draft_participant.draft)
  end

  def show
    @participant_pick = ParticipantPick.find(params[:id])

    render layout: false
  end

  def edit
    @participant_pick = ParticipantPick.find(params[:id])

    render layout: false
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

  def hovercard
    @draft_participant = ParticipantPick.find(params[:id]).draft_participant

    render layout: false
  end

  private

  def create_params
    params.require(:participant_pick).permit(
      :cube_card_id,
      :draft_participant_id,
      :participant_pick_id
    )
  end

  def update_params
    params.require(:participant_pick).permit(:comment)
  end
end
