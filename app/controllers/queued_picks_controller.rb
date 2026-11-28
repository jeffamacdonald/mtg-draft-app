class QueuedPicksController < ApplicationController
  before_action :authorize_new, only: :new
  before_action :authorize_create, only: :create
  before_action :authorize_destroy, only: :destroy

	def new
    @cube_card = CubeCard.find(params[:cube_card_id])
	end

	def create
		QueuedPick.create(create_params)

		respond_to do |format|
      format.turbo_stream
      format.html { redirect_to draft_path(DraftParticipant.find(create_params[:draft_participant_id]).draft), notice: "Added to queue" }
    end
	end

	def destroy
		@queued_pick.destroy!
		respond_to do |format|
      format.turbo_stream do
        # The card modal (draft view) closes; the queue page's card disappears. Each is a no-op where absent.
        render turbo_stream: [
          turbo_stream.update("modal", ""),
          turbo_stream.remove("#{@queued_pick.id}_border")
        ]
      end
      format.html { redirect_to pick_queue_draft_participant_path(@queued_pick.draft_participant) }
    end
	end

	def update_order
    own_queued_picks = QueuedPick.joins(:draft_participant).where(draft_participants: { user_id: current_user.id })

    QueuedPick.transaction do
      Array(params[:queued_pick_ids]).each.with_index(1) do |id, priority_number|
        own_queued_picks.where(id: id.to_s).update_all(priority_number: priority_number)
      end
    end

    head :ok
  end

	private

  def authorize_new
    @draft_participant = DraftParticipant.find(params[:draft_participant_id])
    require_own_draft_participant(@draft_participant)
  end

  def authorize_create
    require_own_draft_participant(DraftParticipant.find(create_params[:draft_participant_id]))
  end

  def authorize_destroy
    @queued_pick = QueuedPick.find(params[:id])
    require_own_draft_participant(@queued_pick.draft_participant)
  end

	def create_params
		params.require(:queued_pick).permit(:cube_card_id, :draft_participant_id, :priority_number)
	end
end
