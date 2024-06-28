FactoryBot.define do
  factory :surrogate_draft_participant do
    draft_participant
    surrogate_participant { create :draft_participant }
  end
end
