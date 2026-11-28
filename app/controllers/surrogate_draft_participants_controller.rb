class SurrogateDraftParticipantsController < ApplicationController
  before_action :authorize_new, only: :new
  before_action :authorize_create, only: :create

  def new
    @available_surrogates = @draft_participant.draft.draft_participants.where.not(id: @draft_participant.id)
  end

  def create
    surrogate_draft_participant = SurrogateDraftParticipant.create!(create_params)
    redirect_to draft_path(surrogate_draft_participant.draft_participant.draft)
  end

  private

  # Only the drafter may choose who picks for them
  def authorize_new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    require_own_draft_participant(@draft_participant)
  end

  def authorize_create
    require_own_draft_participant(DraftParticipant.find(create_params[:draft_participant_id]))
  end

  def create_params
    params.require(:surrogate_draft_participant).permit(
      :draft_participant_id,
      :surrogate_participant_id
    )
  end
end
