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
