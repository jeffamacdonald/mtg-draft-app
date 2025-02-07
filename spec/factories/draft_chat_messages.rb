# == Schema Information
#
# Table name: draft_chat_messages
#
#  id                  :uuid             not null, primary key
#  text                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  draft_id            :uuid
#  participant_pick_id :uuid
#  user_id             :uuid
#
# Indexes
#
#  index_draft_chat_messages_on_draft_id             (draft_id)
#  index_draft_chat_messages_on_participant_pick_id  (participant_pick_id)
#  index_draft_chat_messages_on_user_id              (user_id)
#
FactoryBot.define do
  factory :draft_chat_message do
    draft
    user
    text { "some message" }
  end
end
