class ConfirmTransferPortalTransactionJob < ApplicationJob
  queue_as :default

  def perform(transfer_portal_transaction)
    if transfer_portal_transaction.accepted?
      transfer_portal_transaction.confirm!
    end
  end
end