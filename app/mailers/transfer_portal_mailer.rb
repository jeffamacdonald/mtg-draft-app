class TransferPortalMailer < ApplicationMailer
  def transfer_proposed_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    receivers = transfer_portal_transaction.transfer_portal_transaction_offerings.map(&:receiver).uniq.select do |draft_participant|
      draft_participant.id != transfer_portal_transaction.offerer.id
    end
    to = receivers.map { |draft_participant| draft_participant.user.email }
    mail(to: to, subject: "A Trade Proposal")
  end

  def transfer_initiated_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    to = @draft.draft_participants.map do |draft_participant|
      draft_participant.user.email
    end
    mail(to: to, subject: "A Trade Has Been Accepted")
  end

  def transfer_canceled_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    to = @draft.draft_participants.map do |draft_participant|
      draft_participant.user.email
    end
    mail(to: to, subject: "A Trade Has Been Canceled")
  end

  def transfer_rejected_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    mail(to: transfer_portal_transaction.offerer.user.email, subject: "Your Offer Has Been Rejected")
  end

  def transfer_confirmed_email(transfer_portal_transaction)
    @transfer_portal_transaction = transfer_portal_transaction
    @draft = transfer_portal_transaction.draft
    to = @draft.draft_participants.map do |draft_participant|
      draft_participant.user.email
    end
    mail(to: to, subject: "A Trade Has Gone Through!")
  end
end
