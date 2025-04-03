class TransferPortalTransactionComponent < ViewComponent::Base
	def initialize(transfer_portal_transaction:)
		@transfer_portal_transaction = transfer_portal_transaction
	end
end