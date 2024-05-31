require 'rails_helper'

RSpec.describe Draft do
  describe '#set_participant_positions' do
    let!(:draft) { create :draft }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: nil }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: nil }

    subject { draft.set_participant_positions }

    before do
      allow_any_instance_of(Array).to receive(:shuffle).and_return([draft_participant_2, draft_participant_1])
    end

    it 'participant positions are randomized' do
      expect(draft_participant_1).to receive(:update).with(draft_position: 2)
      expect(draft_participant_2).to receive(:update).with(draft_position: 1)
      subject
    end
  end

  describe '#active_participant' do
    let(:draft) { create :draft }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: 1 }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2 }
    let!(:draft_participant_3) { create :draft_participant, draft_id: draft.id, draft_position: 3 }

    subject { draft.active_participant }

    context 'when no picks have been made' do
      it 'draft position one is active drafter' do
        expect(subject).to eq draft_participant_1
      end
    end

    context 'when picks have been made' do
      let(:draft) { create :draft, active_round: 2 }
      let!(:participant_pick_1) do
        create :participant_pick,
          draft_participant_id: draft_participant_1.id,
          round: 1,
          pick_number: 1
      end
      let!(:participant_pick_2) do
        create :participant_pick,
          draft_participant_id: draft_participant_2.id,
          round: 1,
          pick_number: 2
      end
      let!(:participant_pick_3) do
        create :participant_pick,
          draft_participant_id: draft_participant_3.id,
          round: 1,
          pick_number: 3
      end

      it 'drafter with pick_number 4 as next pick is active' do
        expect(subject).to eq draft_participant_3
      end

      context 'multiple drafters are skipped' do
        before do
          draft_participant_3.skipped = true
          draft_participant_3.save
          draft_participant_2.skipped = true
          draft_participant_2.save
        end

        it 'active drafter is the first that is not skipped' do
          expect(subject).to eq draft_participant_1
        end
      end
    end
  end
end
