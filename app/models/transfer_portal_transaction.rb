# == Schema Information
#
# Table name: transfer_portal_transactions
#
#  id         :uuid             not null, primary key
#  expires_at :datetime
#  status     :string           default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  draft_id   :uuid             not null
#
# Indexes
#
#  index_transfer_portal_transactions_on_draft_id  (draft_id)
#
# Foreign Keys
#
#  fk_rails_...  (draft_id => drafts.id)
#
class TransferPortalTransaction < ApplicationRecord
	belongs_to :draft
	has_many :transfer_portal_transaction_offerings

	STATUSES = %w[pending accepted rejected canceled confirmed].freeze
	enum :status, STATUSES.zip(STATUSES).to_h

	def receiving_participants
		transfer_portal_transaction_offerings.map(&:receiver)
	end

	def receiver_display_names(draft_participant)
		offerings = transfer_portal_transaction_offerings.where(receiver_id: draft_participant)
		offerings.map do |offering|
			offering.participant_pick.display_name
		end
	end
end
