class TransferPortalComponent < ViewComponent::Base
	def initialize(draft:, draft_participant:)
		@draft = draft
		@draft_participant = draft_participant
		@transfer_requests = draft.transfer_portal_transactions.pending.where(offerer: draft_participant).distinct
		@pending_transfers = draft.transfer_portal_transactions.pending_offers_by_draft_participant(draft_participant)
		@accepted_transfers = draft.transfer_portal_transactions.accepted
		@confirmed_transfers = draft.transfer_portal_transactions.confirmed
		@canceled_transfers = draft.transfer_portal_transactions.canceled
	end
end