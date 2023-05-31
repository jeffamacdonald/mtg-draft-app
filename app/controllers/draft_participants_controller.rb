class DraftParticipantsController < ApplicationController
  def new
    @draft = Draft.find(params[:draft_id])
  end

  def create
    DraftParticipant.create(create_params)
    redirect_to drafts_path
  end

  private

  def create_params
    params.require(:draft_participant).permit(
      :draft_id,
      :user_id
    )
  end
end
