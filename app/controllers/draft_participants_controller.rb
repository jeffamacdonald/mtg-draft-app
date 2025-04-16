class DraftParticipantsController < ApplicationController
  def new
    @draft = Draft.find(params[:draft_id])
  end

  def create
    draft_participant = DraftParticipant.create(create_params)
    draft_participant.set_display_color!
    redirect_to draft_path(draft_participant.draft)
  end

  def edit
    @draft_participant = DraftParticipant.find(params[:id])
  end

  def update
    @draft_participant = DraftParticipant.find(params[:id])
    @draft_participant.update!(update_params)

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = "Settings saved" }
      format.html do
        flash[:success] = "Settings saved"
        redirect_to draft_path(@draft_participant.draft)
      end
    end
  end

  def picks
    @draft_participant = DraftParticipant.find(params[:id])
  end

  def pick_queue
    @draft_participant = DraftParticipant.find(params[:id])

    redirect_to draft_path(@draft_participant.draft) if @draft_participant.user != current_user
  end

  private

  def create_params
    params.require(:draft_participant).permit(
      :draft_id,
      :user_id,
      :display_name
    )
  end

  def update_params
    params.require(:draft_participant).permit(
      :display_name,
      :queue_active,
      :queue_minute_delay
    )
  end
end
