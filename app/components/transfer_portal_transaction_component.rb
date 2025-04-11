class TransferPortalTransactionComponent < ViewComponent::Base
	def initialize(transfer_portal_transaction:, pending_actions: false, cancel_action: false)
		@transfer_portal_transaction = transfer_portal_transaction
		@pending_actions = pending_actions
		@cancel_action = cancel_action
	end
end