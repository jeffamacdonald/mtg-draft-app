# == Schema Information
#
# Table name: queued_picks
#
#  id                   :uuid             not null, primary key
#  priority_number      :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cube_card_id         :uuid
#  draft_participant_id :uuid
#
# Indexes
#
#  index_queued_picks_on_cube_card_id          (cube_card_id)
#  index_queued_picks_on_draft_participant_id  (draft_participant_id)
#
# Foreign Keys
#
#  fk_rails_...  (cube_card_id => cube_cards.id)
#  fk_rails_...  (draft_participant_id => draft_participants.id)
#
require 'rails_helper'

RSpec.describe QueuedPick, type: :model do
	describe "#handle_cube_card_picked!" do
		let!(:draft) { create :draft }
	  let!(:draft_participant) { create :draft_participant, draft: }
	  let!(:queued_pick_1) { create :queued_pick, draft_participant: draft_participant, priority_number: 1 }
	  let!(:queued_pick_2) { create :queued_pick, draft_participant: draft_participant, priority_number: 2 }
	  let!(:queued_pick_3) { create :queued_pick, draft_participant: draft_participant, priority_number: 3 }
	  let!(:queued_pick_4) { create :queued_pick, draft_participant: draft_participant, priority_number: 4 }

		it "updates other queued pick priority numbers and destroys self" do
			queued_pick_2.handle_cube_card_picked!

			expect(queued_pick_1.reload.priority_number).to eq 1
			expect(queued_pick_3.reload.priority_number).to eq 2
			expect(queued_pick_4.reload.priority_number).to eq 3
			expect(queued_pick_2).to be_destroyed
		end
	end
end
