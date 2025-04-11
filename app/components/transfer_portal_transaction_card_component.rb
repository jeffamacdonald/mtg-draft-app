class TransferPortalTransactionCardComponent < ViewComponent::Base
	def initialize(card_header:, transfer_portal_transactions:, pending_actions:, cancel_action:, draft_participant: nil)
		@card_header = card_header
		@transfer_portal_transactions = transfer_portal_transactions
		@pending_actions = pending_actions
		@cancel_action = cancel_action
		@draft_participant = draft_participant
	end

	def render?
		@transfer_portal_transactions.present?
	end
end