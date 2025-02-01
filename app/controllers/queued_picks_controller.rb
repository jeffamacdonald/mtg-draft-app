class QueuedPicksController < ApplicationController
	def new
		@draft_participant = DraftParticipant.find(params[:draft_participant_id])
    @cube_card = CubeCard.find(params[:cube_card_id])
	end

	def create
		QueuedPick.create(create_params)

		respond_to do |format|
      format.turbo_stream
      format.html { redirect_to draft_path(DraftParticipant.find(create_params[:draft_participant_id]).draft), notice: "Added to queue" }
    end
	end

	private

	def create_params
		params.require(:queued_pick).permit(:cube_card_id, :draft_participant_id, :priority_number)
	end
end