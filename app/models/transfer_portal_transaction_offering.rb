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
class TransferPortalTransactionOffering < ApplicationRecord
	belongs_to :transfer_portal_transaction
	belongs_to :sender, class_name: "DraftParticipant", foreign_key: :draft_participant_id
	belongs_to :receiver, class_name: "DraftParticipant", foreign_key: :draft_participant_id
	belongs_to :participant_pick

	def transfer!
		participant_pick.update!(draft_participant: receiver)
	end
end
