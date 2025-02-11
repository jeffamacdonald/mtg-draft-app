# == Schema Information
#
# Table name: surrogate_draft_participants
#
#  id                       :uuid             not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  draft_participant_id     :uuid
#  surrogate_participant_id :uuid
#
# Indexes
#
#  index_surrogate_draft_participants_on_draft_participant_id      (draft_participant_id)
#  index_surrogate_draft_participants_on_surrogate_participant_id  (surrogate_participant_id)
#
# Foreign Keys
#
#  fk_rails_...  (draft_participant_id => draft_participants.id)
#  fk_rails_...  (surrogate_participant_id => draft_participants.id)
#
FactoryBot.define do
  factory :surrogate_draft_participant do
    draft_participant
    surrogate_participant { create :draft_participant }
  end
end
