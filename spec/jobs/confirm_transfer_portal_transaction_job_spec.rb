require 'rails_helper'

RSpec.describe ConfirmTransferPortalTransactionJob, type: :job do
  describe '#perform' do
    let(:draft) { create(:draft) }
    let(:offerer) { create(:draft_participant, draft: draft) }

    context 'when transaction is accepted' do
      let(:transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, status: 'accepted') }

      it 'confirms the transaction' do
        expect(transaction).to receive(:confirm!)

        described_class.perform_now(transaction)
      end
    end

    context 'when transaction is not accepted' do
      let(:transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, status: 'pending') }

      it 'does not confirm the transaction' do
        expect(transaction).not_to receive(:confirm!)

        described_class.perform_now(transaction)
      end
    end
  end
end
