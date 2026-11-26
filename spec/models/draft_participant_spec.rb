# == Schema Information
#
# Table name: draft_participants
#
#  id                 :uuid             not null, primary key
#  display_color      :string
#  display_name       :string           not null
#  draft_position     :integer
#  queue_active       :boolean          default(FALSE), not null
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
#  index_draft_participants_on_draft_position_skipped       (draft_id,draft_position,skipped)
#  index_draft_participants_on_surrogate_user_id            (surrogate_user_id)
#  index_draft_participants_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (draft_id => drafts.id)
#  fk_rails_...  (surrogate_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe DraftParticipant do
  describe "#can_pick_for?" do
    let(:draft) { create :draft }
    let(:draft_participant) { create :draft_participant, draft: }
    let(:other_participant) { create :draft_participant, draft: }

    context "when draft participant is self" do
      it "returns true" do
        expect(draft_participant.can_pick_for?(draft_participant)).to eq true
      end
    end

    context "when draft participant has self as a surrogate" do
      let!(:surrogate_draft_participant) { create :surrogate_draft_participant, draft_participant: other_participant, surrogate_participant: draft_participant }

      it "returns true" do
        expect(draft_participant.can_pick_for?(other_participant)).to eq true
      end
    end

    context "when draft participant does not have self as a surrogate" do
      it "returns false" do
        expect(draft_participant.can_pick_for?(other_participant)).to eq false
      end
    end
  end
end
