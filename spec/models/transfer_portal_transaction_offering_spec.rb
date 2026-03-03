# == Schema Information
#
# Table name: transfer_portal_transaction_offerings
#
#  id                             :uuid             not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  participant_pick_id            :uuid             not null
#  receiver_id                    :uuid             not null
#  sender_id                      :uuid             not null
#  transfer_portal_transaction_id :uuid             not null
#
# Indexes
#
#  idx_on_participant_pick_id_a1ed08093d                       (participant_pick_id)
#  idx_on_transfer_portal_transaction_id_03d80ed631            (transfer_portal_transaction_id)
#  index_transfer_portal_transaction_offerings_on_receiver_id  (receiver_id)
#  index_transfer_portal_transaction_offerings_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (participant_pick_id => participant_picks.id)
#  fk_rails_...  (receiver_id => draft_participants.id)
#  fk_rails_...  (sender_id => draft_participants.id)
#  fk_rails_...  (transfer_portal_transaction_id => transfer_portal_transactions.id)
#
require 'rails_helper'

RSpec.describe TransferPortalTransactionOffering do
  let(:draft) { create(:draft) }
  let(:offerer) { create(:draft_participant, draft: draft) }
  let(:sender) { create(:draft_participant, draft: draft) }
  let(:receiver) { create(:draft_participant, draft: draft) }
  let(:transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer) }
  let(:cube_card) { create(:cube_card, cube: draft.cube) }
  let(:participant_pick) { create(:participant_pick, draft_participant: sender, cube_card: cube_card) }
  let(:offering) { create(:transfer_portal_transaction_offering,
    transfer_portal_transaction: transaction,
    sender: sender,
    receiver: receiver,
    participant_pick: participant_pick
  )}

  describe '#transfer!' do
    it 'updates participant_pick to belong to receiver' do
      offering.transfer!

      participant_pick.reload
      expect(participant_pick.draft_participant).to eq(receiver)
    end
  end

  describe 'validations' do
    describe 'any_picks_in_pending_trade' do
      context 'when pick is already in an active trade' do
        let!(:another_transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, status: 'pending') }
        let!(:existing_offering) { create(:transfer_portal_transaction_offering,
          transfer_portal_transaction: another_transaction,
          participant_pick: participant_pick
        )}

        it 'is invalid' do
          new_offering = build(:transfer_portal_transaction_offering,
            transfer_portal_transaction: transaction,
            participant_pick: participant_pick
          )

          expect(new_offering).not_to be_valid
          expect(new_offering.errors[:base]).to include("Cannot trade picks that are still in an active trade")
        end
      end

      context 'when pick is not in any active trade' do
        it 'is valid' do
          expect(offering).to be_valid
        end
      end

      context 'when pick is in a completed trade' do
        let!(:completed_transaction) { create(:transfer_portal_transaction, draft: draft, offerer: offerer, status: 'confirmed') }
        let!(:completed_offering) { create(:transfer_portal_transaction_offering,
          transfer_portal_transaction: completed_transaction,
          participant_pick: participant_pick
        )}

        it 'is valid' do
          new_offering = build(:transfer_portal_transaction_offering,
            transfer_portal_transaction: transaction,
            participant_pick: participant_pick
          )

          expect(new_offering).to be_valid
        end
      end
    end
  end
end
