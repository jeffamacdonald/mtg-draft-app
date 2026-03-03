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
FactoryBot.define do
  factory :transfer_portal_transaction do
    association :draft
    association :offerer, factory: :draft_participant
    status { 'pending' }
  end
end
