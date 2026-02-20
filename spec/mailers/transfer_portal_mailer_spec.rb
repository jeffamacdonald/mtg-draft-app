require 'rails_helper'

RSpec.describe TransferPortalMailer, type: :mailer do
  let(:draft) { create(:draft, name: 'Test Draft') }
  let(:offerer) { create(:draft_participant, draft: draft) }
  let(:receiver) { create(:draft_participant, draft: draft) }
  let(:transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, expires_at: 2.days.from_now) }
  let!(:offering) { create(:transfer_portal_transaction_offering,
    transfer_portal_transaction: transaction,
    receiver: receiver,
    sender: offerer
  )}

  describe '#transfer_proposed_email' do
    let(:mail) { TransferPortalMailer.transfer_proposed_email(transaction) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq('A Trade Proposal')
    end

    it 'sends to receiving participants' do
      expect(mail.to).to include(receiver.user.email)
    end

    it 'does not send to the offerer' do
      expect(mail.to).not_to include(offerer.user.email)
    end

    it 'assigns transaction and draft' do
      expect(mail.body.encoded).to match(/transfer_portal_transaction/)
      expect(mail.body.encoded).to match(/draft/)
    end
  end

  describe '#transfer_initiated_email' do
    let(:mail) { TransferPortalMailer.transfer_initiated_email(transaction) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq('A Trade Has Been Accepted')
    end

    it 'sends to all draft participants' do
      expect(mail.to).to include(offerer.user.email, receiver.user.email)
    end

    it 'assigns transaction and draft' do
      expect(mail.body.encoded).to match(/transfer_portal_transaction/)
      expect(mail.body.encoded).to match(/draft/)
    end
  end

  describe '#transfer_canceled_email' do
    let(:mail) { TransferPortalMailer.transfer_canceled_email(transaction) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq('A Trade Has Been Canceled')
    end

    it 'sends to all draft participants' do
      expect(mail.to).to include(offerer.user.email, receiver.user.email)
    end

    it 'assigns transaction and draft' do
      expect(mail.body.encoded).to match(/transfer_portal_transaction/)
      expect(mail.body.encoded).to match(/draft/)
    end
  end

  describe '#transfer_rejected_email' do
    let(:mail) { TransferPortalMailer.transfer_rejected_email(transaction) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq('Your Offer Has Been Rejected')
    end

    it 'sends to the offerer' do
      expect(mail.to).to eq([offerer.user.email])
    end

    it 'assigns transaction and draft' do
      expect(mail.body.encoded).to match(/transfer_portal_transaction/)
      expect(mail.body.encoded).to match(/draft/)
    end
  end

  describe '#transfer_confirmed_email' do
    let(:mail) { TransferPortalMailer.transfer_confirmed_email(transaction) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq('A Trade Has Gone Through!')
    end

    it 'sends to all draft participants' do
      expect(mail.to).to include(offerer.user.email, receiver.user.email)
    end

    it 'assigns transaction and draft' do
      expect(mail.body.encoded).to match(/transfer_portal_transaction/)
      expect(mail.body.encoded).to match(/draft/)
    end
  end
end
