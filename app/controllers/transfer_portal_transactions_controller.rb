class TransferPortalTransactionsController < ApplicationController
	before_action :set_draft, only: [:index, :create]
	before_action :set_transfer_portal_transaction, only: [:accept, :cancel, :reject]

	def index
		@draft_participant = @draft.draft_participants.find_by(user: current_user)
	end

	def new
		@draft_participant = DraftParticipant.find(params[:draft_participant_id])
	  @sender = @draft_participant.draft.draft_participants.find_by(user: current_user)
	  
	  render turbo_stream: turbo_stream.replace(
	    "transfer-portal-draft-participants",
	    render_to_string(
	      TransferPortalTransactionFormComponent.new(
	        sender: @sender,
	        receiver: @draft_participant
	      )
	    )
	  )
	end

	def create
		offerer_participant = @draft.draft_participants.find_by(user: current_user)
		ActiveRecord::Base.transaction do
			transfer_portal_transaction = TransferPortalTransaction.create!(draft: @draft, offerer: offerer_participant)

			params["offerer_participant_pick_ids"].each do |participant_pick_id|
				transfer_portal_transaction.transfer_portal_transaction_offerings.create!(
					sender_id: offerer_participant.id,
					receiver_id: params[:draft_participant_id],
					participant_pick_id:
				)
			end

			params["offeree_participant_pick_ids"].each do |participant_pick_id|
				transfer_portal_transaction.transfer_portal_transaction_offerings.create!(
					receiver_id: offerer_participant.id,
					sender_id: params[:draft_participant_id],
					participant_pick_id:
				)
			end
			TransferPortalMailer.transfer_proposed_email(transfer_portal_transaction).deliver_now
		end

		flash[:success] = "Offer sent!"
		redirect_to draft_path(@draft)
	rescue ActiveRecord::RecordInvalid => ex
		flash[:error] = ex.record.errors.full_messages.join(", ")
		redirect_to draft_transfer_portal_transactions_path(@draft)
	end

	def accept
		@transfer_portal_transaction.accept!

		flash[:success] = "Accepted offer will be transfered in 2 business days"
		redirect_to draft_path(@transfer_portal_transaction.draft)
	end

	def cancel
		@transfer_portal_transaction.cancel!

		flash[:success] = "Offer canceled!"
		redirect_to draft_path(@transfer_portal_transaction.draft)
	end

	def reject
		@transfer_portal_transaction.reject!

		flash[:success] = "Offer rejected!"
		redirect_to draft_path(@transfer_portal_transaction.draft)
	end

	private

	def set_draft
		@draft = Draft.find params[:draft_id]
	end

	def set_transfer_portal_transaction
		@transfer_portal_transaction = TransferPortalTransaction.find params[:id]
	end
end