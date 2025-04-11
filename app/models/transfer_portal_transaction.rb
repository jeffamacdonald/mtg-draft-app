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
		# TODO: send email
		update!(expires_at: two_business_days_away)
		accepted!
	end

	def cancel!
		# TODO: send email
		canceled!
	end

	def reject!
		# TODO: send email
		rejected!
	end

	def confirm!
		transfer_portal_transaction_offerings.each(&:transfer!)
		confirmed!
	end

	private

	def two_business_days_away
		two_days = 2.days.from_now
		while day_off?(two_days)
			two_days = two_days + 1.day
		end
		two_days
	end

	def day_off?(date_time)
    weekend?(date_time) || Holidays.on(date_time, :us_ca, :observed).present?
  end

  def weekend?(date_time)
    date_time.wday == 0 || date_time.wday == 6
  end
end
