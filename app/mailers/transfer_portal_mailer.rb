class TransferPortalMailer < ApplicationMailer
  def transfer_initiated_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    @draft.draft_participants.each do |draft_participant|
      @offerer = transfer_portal_transaction.offerer == draft_participant
      @trade_participant = transfer_portal_transaction.transfer_portal_transaction_offerings.where(receiver: draft_participant).exists?
      mail(to: draft_participant.user.email, subject: "A Trade Has Been Accepted")
    end
  end

  def transfer_canceled_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    @draft.draft_participants.each do |draft_participant|
      mail(to: draft_participant.user.email, subject: "A Trade Has Been Canceled")
    end
  end

  def transfer_rejected_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    mail(to: transfer_portal_transaction.offerer.user.email, subject: "Your Offer Has Been Rejected")
  end

  def transfer_confirmed_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    @draft.draft_participants.each do |draft_participant|
      mail(to: draft_participant.user.email, subject: "A Trade Has Gone Through!")
    end
  end
end
