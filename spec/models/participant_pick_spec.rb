# == Schema Information
#
# Table name: participant_picks
#
#  id                   :uuid             not null, primary key
#  comment              :string           default("")
#  pick_number          :integer          not null
#  round                :integer          not null
#  skipped              :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cube_card_id         :uuid
#  draft_participant_id :uuid
#
# Indexes
#
#  index_participant_picks_on_cube_card_id          (cube_card_id)
#  index_participant_picks_on_draft_participant_id  (draft_participant_id)
#  index_participant_picks_on_round                 (round)
#
# Foreign Keys
#
#  fk_rails_...  (cube_card_id => cube_cards.id)
#  fk_rails_...  (draft_participant_id => draft_participants.id)
#
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
