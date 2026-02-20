FactoryBot.define do
  factory :transfer_portal_transaction_offering do
    association :transfer_portal_transaction
    association :sender, factory: :draft_participant
    association :receiver, factory: :draft_participant
    association :participant_pick
  end
end
