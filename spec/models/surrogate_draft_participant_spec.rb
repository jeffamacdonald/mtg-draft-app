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
require 'rails_helper'

RSpec.describe SurrogateDraftParticipant do
  let(:draft) { create(:draft) }
  let(:draft_participant) { create(:draft_participant, draft: draft) }
  let(:surrogate_participant) { create(:draft_participant, draft: draft) }
  let(:surrogate) { create(:surrogate_draft_participant,
    draft_participant: draft_participant,
    surrogate_participant: surrogate_participant
  )}

  describe '#draft' do
    it 'returns the draft through draft_participant' do
      expect(surrogate.draft_participant.draft).to eq(draft)
    end
  end

  describe '#surrogate_participant' do
    it 'returns the surrogate participant' do
      expect(surrogate.surrogate_participant).to eq(surrogate_participant)
    end
  end
end
