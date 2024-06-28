require 'rails_helper'

RSpec.describe ParticipantPick, type: :model do
  describe 'validations' do
    context 'when card has already been picked' do
      let!(:cube) { create :cube }
      let!(:cube_card) { create :cube_card, cube_id: cube.id }
      let!(:draft) { create :draft, cube_id: cube.id }
      let!(:dp1) { create :draft_participant, draft_id: draft.id }
      let!(:dp2) { create :draft_participant, draft_id: draft.id }
      let!(:participant_pick_1) { create :participant_pick, draft_participant_id: dp1.id, cube_card_id: cube_card.id }

      it 'fails validation' do
        record = ParticipantPick.new
        record.draft_participant = dp2
        record.cube_card_id = cube_card.id
        expect(record.valid?).to eq false
        expect(record.errors[:cube_card_id]).to include 'Card Is Not Available'
      end
    end
  end

  describe "update_draft_round" do
    let!(:draft) { create :draft, active_round: 1, rounds: 2 }
    let!(:dp1) { create :draft_participant, draft: }
    let!(:dp2) { create :draft_participant, draft: }


    context "when it is the last pick of the draft" do
      let!(:participant_pick_1) { create :participant_pick, draft_participant: dp1, pick_number: 1 }
      let!(:participant_pick_2) { create :participant_pick, draft_participant: dp2, pick_number: 2 }
      let!(:participant_pick_3) { create :participant_pick, draft_participant: dp2, pick_number: 3 }
      let(:participant_pick_4) { build :participant_pick, draft_participant: dp1, pick_number: 4 }

      it "does nothing" do
        allow(participant_pick_4).to receive(:draft).and_return(draft)

        expect{
          participant_pick_4.save!
        }.not_to change(draft, :active_round)
      end
    end

    context "when it is the last pick of the round" do
      let!(:participant_pick_1) { create :participant_pick, draft_participant: dp1, pick_number: 1 }
      let(:participant_pick_2) { build :participant_pick, draft_participant: dp2, pick_number: 2 }

      it "active_round is incremented by 1" do
        allow(participant_pick_2).to receive(:draft).and_return(draft)

        expect{
          participant_pick_2.save!
        }.to change(draft, :active_round).from(1).to(2)
      end

      context "when it is a skipped pick" do
        let!(:dp2) { create :draft_participant, draft:, skipped: true }
        let!(:participant_pick_1) { create :participant_pick, draft_participant: dp1, pick_number: 1 }
        let!(:participant_pick_4) { create :participant_pick, draft_participant: dp1, pick_number: 4 }
        let(:participant_pick_2) { build :participant_pick, draft_participant: dp2, pick_number: 2 }

        it "does nothing" do
          allow(participant_pick_2).to receive(:draft).and_return(draft)

          expect{
            participant_pick_2.save!
          }.not_to change(draft, :active_round)
        end
      end
    end

    context "when it is not the last pick of the round" do
      let(:participant_pick_1) { build :participant_pick, draft_participant: dp2, pick_number: 1 }

      it "active_round stays the same" do
        allow(participant_pick_1).to receive(:draft).and_return(draft)

        expect{
          participant_pick_1.save!
        }.not_to change(draft, :active_round)
      end
    end
  end
end
