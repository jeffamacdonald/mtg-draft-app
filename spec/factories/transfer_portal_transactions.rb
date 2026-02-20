FactoryBot.define do
  factory :transfer_portal_transaction do
    association :draft
    association :offerer, factory: :draft_participant
    status { 'pending' }
  end
end
