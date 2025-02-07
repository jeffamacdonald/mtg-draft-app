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

	def destroy
		@queued_pick = QueuedPick.find params[:id]
		@queued_pick.destroy!
		respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(
          "#{@queued_pick.id}_border"
        )
      end
      format.html { redirect_to pick_queue_draft_participant_path(@queued_pick.draft_participant) }
    end
	end

	def update_order
    queued_pick_ids = params[:queued_pick_ids]

	  # Generate a SQL CASE statement to update all records in one query
	  case_statements = queued_pick_ids.map.with_index(1) do |id, index|
      "WHEN '#{id}' THEN #{index}"
    end.join(" ")

    # Execute the update in a single SQL query
    sql = <<-SQL
      UPDATE queued_picks
      SET priority_number = CASE id #{case_statements} END
      WHERE id IN (#{queued_pick_ids.map { |id| "'#{id}'" }.join(", ")})
    SQL

	  ActiveRecord::Base.connection.execute(sql)

    head :ok
  end

	private

	def create_params
		params.require(:queued_pick).permit(:cube_card_id, :draft_participant_id, :priority_number)
	end
end