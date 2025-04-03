class TransferPortalComponent < ViewComponent::Base
	def initialize(draft:)
		@accepted_transfers = draft.transfer_portal_transactions.accepted
		@completed_transfers = draft.transfer_portal_transactions.completed
		@canceled_transfers = draft.transfer_portal_transactions.canceled
	end
end