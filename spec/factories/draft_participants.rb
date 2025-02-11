# == Schema Information
#
# Table name: draft_participants
#
#  id                 :uuid             not null, primary key
#  display_name       :string           not null
#  draft_position     :integer
#  queue_active       :boolean          default(TRUE), not null
#  queue_minute_delay :integer          default(0), not null
#  skipped            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  draft_id           :uuid
#  surrogate_user_id  :uuid
#  user_id            :uuid
#
# Indexes
#
#  index_draft_participants_on_draft_id                     (draft_id)
#  index_draft_participants_on_draft_id_and_draft_position  (draft_id,draft_position) UNIQUE
#  index_draft_participants_on_draft_id_and_user_id         (draft_id,user_id) UNIQUE
#  index_draft_participants_on_surrogate_user_id            (surrogate_user_id)
#  index_draft_participants_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (draft_id => drafts.id)
#  fk_rails_...  (surrogate_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :draft_participant do
    transient do
      draft { create :draft }
      user { create :user }
    end
    draft_id { draft.id }
    user_id { user.id }
    sequence(:display_name) { |n| "participant#{n}" }
    sequence(:draft_position) { |n| n }
  end
end
