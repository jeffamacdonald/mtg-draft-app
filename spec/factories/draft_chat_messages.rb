FactoryBot.define do
  factory :draft_chat_message do
    draft
    user
    text { "some message" }
  end
end
