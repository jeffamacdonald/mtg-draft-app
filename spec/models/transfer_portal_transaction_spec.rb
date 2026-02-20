require 'rails_helper'

RSpec.describe TransferPortalTransaction do
  let(:draft) { create(:draft) }
  let(:offerer) { create(:draft_participant, draft: draft) }
  let(:receiver) { create(:draft_participant, draft: draft) }
  let(:transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer) }

  describe 'scopes' do
    describe '.pending_offers_by_draft_participant' do
      let!(:other_participant) { create(:draft_participant, draft: draft) }
      let!(:other_transaction) { create(:transfer_portal_transaction, draft: draft, offerer: other_participant, status: 'pending') }
      let!(:offering) { create(:transfer_portal_transaction_offering, transfer_portal_transaction: other_transaction, receiver: offerer, sender: other_participant) }

      it 'returns transactions where the participant is a receiver' do
        expect(described_class.pending_offers_by_draft_participant(offerer)).to include(other_transaction)
      end

      it 'excludes transactions where the participant is the offerer' do
        expect(described_class.pending_offers_by_draft_participant(offerer)).not_to include(transaction)
      end
    end

    describe '.active' do
      let!(:pending_transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, status: 'pending') }
      let!(:accepted_transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, status: 'accepted') }
      let!(:rejected_transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, status: 'rejected') }

      it 'includes pending and accepted transactions' do
        active = described_class.active
        expect(active).to include(pending_transaction, accepted_transaction)
        expect(active).not_to include(rejected_transaction)
      end
    end
  end

  describe '#receiving_participants' do
    let!(:offering1) { create(:transfer_portal_transaction_offering, transfer_portal_transaction: transaction, receiver: receiver) }
    let!(:offering2) { create(:transfer_portal_transaction_offering, transfer_portal_transaction: transaction, receiver: receiver) }

    it 'returns unique receiving participants' do
      expect(transaction.receiving_participants).to eq([receiver])
    end
  end

  describe '#accept!' do
    before do
      allow(transaction).to receive(:update!)
      allow(transaction).to receive(:accepted!)
      allow(ConfirmTransferPortalTransactionJob).to receive_message_chain(:set, :perform_later)
      allow(TransferPortalMailer).to receive_message_chain(:transfer_initiated_email, :deliver_now)
    end

    it 'sets expires_at and changes status to accepted' do
      transaction.accept!

      expect(transaction).to have_received(:update!).with(hash_including(:expires_at))
      expect(transaction).to have_received(:accepted!)
    end

    it 'schedules confirmation job' do
      expect(ConfirmTransferPortalTransactionJob).to receive(:set)
      transaction.accept!
    end

    it 'sends transfer initiated email' do
      expect(TransferPortalMailer).to receive(:transfer_initiated_email).with(transaction)
      transaction.accept!
    end
  end

  describe '#cancel!' do
    before do
      allow(transaction).to receive(:canceled!)
      allow(TransferPortalMailer).to receive_message_chain(:transfer_canceled_email, :deliver_now)
    end

    it 'changes status to canceled and sends email' do
      transaction.cancel!

      expect(transaction).to have_received(:canceled!)
      expect(TransferPortalMailer).to have_received(:transfer_canceled_email).with(transaction)
    end
  end

  describe '#reject!' do
    before do
      allow(transaction).to receive(:rejected!)
      allow(TransferPortalMailer).to receive_message_chain(:transfer_rejected_email, :deliver_now)
    end

    it 'changes status to rejected and sends email' do
      transaction.reject!

      expect(transaction).to have_received(:rejected!)
      expect(TransferPortalMailer).to have_received(:transfer_rejected_email).with(transaction)
    end
  end

  describe '#confirm!' do
    let!(:offering) { create(:transfer_portal_transaction_offering, transfer_portal_transaction: transaction) }

    before do
      allow(offering).to receive(:transfer!)
      allow(transaction.transfer_portal_transaction_offerings).to receive(:each).and_yield(offering)
      allow(transaction).to receive(:confirmed!)
      allow(TransferPortalMailer).to receive_message_chain(:transfer_confirmed_email, :deliver_now)
    end

    it 'transfers all offerings and confirms transaction' do
      transaction.confirm!

      expect(offering).to have_received(:transfer!)
      expect(transaction).to have_received(:confirmed!)
      expect(TransferPortalMailer).to have_received(:transfer_confirmed_email).with(transaction)
    end
  end
end
