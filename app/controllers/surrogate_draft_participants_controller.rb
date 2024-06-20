class SurrogateDraftParticipantsController < ApplicationController
  def new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    @available_surrogates = @draft_participant.draft.draft_participants.where.not(id: @draft_participant.id)
  end

  def create
    surrogate_draft_participant = SurrogateDraftParticipant.create!(create_params)
    redirect_to draft_path(surrogate_draft_participant.draft_participant.draft)
  end

  private

  def create_params
    params.require(:surrogate_draft_participant).permit(
      :draft_participant_id,
      :surrogate_participant_id
    )
  end
end
