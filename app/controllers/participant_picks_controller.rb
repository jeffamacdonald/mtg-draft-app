class ParticipantPicksController < ApplicationController
  def new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    @cube_card = CubeCard.find(params[:cube_card_id])
  end

  # Fills the participant pick with a card
  def pick
    participant_pick = ParticipantPick.find(params[:id])
    draft_participant = participant_pick.draft_participant

    unless may_pick_for?(draft_participant)
      flash[:error] = "You can't make picks for that drafter."
      return redirect_to draft_path(draft_participant.draft), status: :see_other
    end

    cube_card = CubeCard.find(pick_params[:cube_card_id])
    made_pick = Drafts::MakePick.call(draft_participant:, cube_card:, participant_pick_id: participant_pick.id)

    unless Drafts::NotifyNextUp.call(pick: made_pick, except_user: current_user)
      flash[:error] = "Your pick was saved, but the email to the next player failed to send. Please notify the admin."
    end

    redirect_to draft_path(draft_participant.draft), status: :see_other
  rescue Drafts::MakePick::StalePick
    flash[:error] = "That pick wasn't saved. It was already made, or your turn changed."
    redirect_to draft_path(draft_participant.draft), status: :see_other
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

  # The drafter themselves, or one of their surrogates
  def may_pick_for?(draft_participant)
    current_participant = draft_participant.draft.draft_participants.find_by(user: current_user)
    current_participant.present? && current_participant.can_pick_for?(draft_participant)
  end

  def pick_params
    params.require(:participant_pick).permit(:cube_card_id)
  end

  def update_params
    params.require(:participant_pick).permit(:comment)
  end
end
