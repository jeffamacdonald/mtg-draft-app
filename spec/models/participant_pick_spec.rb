require 'rails_helper'

RSpec.describe ParticipantPick, type: :model do
  describe 'validations' do
    let!(:cube) { create :cube }
    let!(:draft) { create :draft, cube_id: cube.id }
    let!(:dp1) { create :draft_participant, draft_id: draft.id }
    let!(:dp2) { create :draft_participant, draft_id: draft.id }

    context 'when card has already been picked' do
      let!(:cube_card) { create :cube_card, cube_id: cube.id }
      let!(:participant_pick_1) { create :participant_pick, draft_participant_id: dp1.id, cube_card_id: cube_card.id }

      it 'fails validation' do
        record = ParticipantPick.new
        record.draft_participant = dp2
        record.cube_card_id = cube_card.id
        expect(record.valid?).to eq false
        expect(record.errors[:cube_card_id]).to include 'Card Is Not Available'
      end
    end

    context "when no cube card is present" do
      it "passes validation" do
        record = ParticipantPick.new
        record.draft_participant = dp2
        record.cube_card_id = nil
        expect(record.valid?).to eq true
      end
    end
  end
end
