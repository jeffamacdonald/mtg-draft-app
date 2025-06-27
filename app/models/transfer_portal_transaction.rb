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
#  offerer_id :uuid             not null
#
# Indexes
#
#  index_transfer_portal_transactions_on_draft_id    (draft_id)
#  index_transfer_portal_transactions_on_offerer_id  (offerer_id)
#
# Foreign Keys
#
#  fk_rails_...  (draft_id => drafts.id)
#  fk_rails_...  (offerer_id => draft_participants.id)
#
class TransferPortalTransaction < ApplicationRecord
	belongs_to :draft
	belongs_to :offerer, class_name: "DraftParticipant"
	has_many :transfer_portal_transaction_offerings

	STATUSES = %w[pending accepted rejected canceled confirmed].freeze
	enum :status, STATUSES.zip(STATUSES).to_h

	scope :pending_offers_by_draft_participant, ->(draft_participant) do
		joins(:transfer_portal_transaction_offerings)
			.pending
			.where.not(offerer: draft_participant)
			.where(transfer_portal_transaction_offerings: { receiver: draft_participant })
	end
	scope :active, -> { where(status: ["pending", "accepted"]) }

	def receiving_participants
		transfer_portal_transaction_offerings.map(&:receiver).uniq
	end

	def receiver_display_names(draft_participant)
		offerings = transfer_portal_transaction_offerings.where(receiver_id: draft_participant)
		offerings.map do |offering|
			offering.participant_pick.display_name
		end
	end

	def accept!
		update!(expires_at: two_business_days_away)
		accepted!
		ConfirmTransferPortalTransactionJob.set(wait: expires_at.to_i - Time.now.to_i).perform_later(self)
		TransferPortalMailer.transfer_initiated_email(self).deliver_now
	end

	def cancel!
		canceled!
		TransferPortalMailer.transfer_canceled_email(self).deliver_now
	end

	def reject!
		rejected!
		TransferPortalMailer.transfer_rejected_email(self).deliver_now
	end

	def confirm!
		transfer_portal_transaction_offerings.each(&:transfer!)
		confirmed!
		TransferPortalMailer.transfer_confirmed_email(self).deliver_now
	end

	private

	def two_business_days_away
		offset = 0
		while day_off?(offset.days.from_now)
			offset += 1
		end
		if offset > 0
			(offset + 2).days.from_now.beginning_of_day
		else
			2.days.from_now
		end
	end

	def day_off?(date_time)
    weekend?(date_time) || Holidays.on(date_time, :us_ca, :observed).present?
  end

  def weekend?(date_time)
    date_time.wday == 0 || date_time.wday == 6
  end
end
