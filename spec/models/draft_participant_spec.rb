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
  describe '#pick_card!' do
    let(:cube) { create :cube }
    let(:draft) { create :draft, cube: cube }
    let(:cube_card) { create :cube_card, cube: cube }
    let!(:participant_1) { create :draft_participant, draft: draft, draft_position: 1 }
    let!(:other_participants) do
      12.times{ |i| create :draft_participant, draft: draft, draft_position: i+2 }
    end
    let!(:participant_14) { create :draft_participant, draft: draft, draft_position: 14 }

    subject { participant_1.pick_card!(cube_card) }

    context 'when no cards are picked yet' do
      let!(:participant_pick_1) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: 1, pick_number: 1 }
      let!(:participant_pick_2) { create :participant_pick, draft_participant: participant_14, cube_card_id: nil, round: 1, pick_number: 2 }

      it 'updates active pick, updates last pick at, enqueues skip job, and broadcasts updates' do
        allow(participant_1).to receive(:draft).and_return(draft)
        expect(draft).to receive(:enqueue_skip_job)
        allow(draft).to receive(:active_pick).and_return(participant_pick_2)
        expect(participant_pick_2).to receive(:enqueue_auto_pick_job)
        expect(RemoveQueuedPicksJob).to receive(:perform_later).with(participant_pick_1)
        expect(Broadcast::DraftUpdateJob).to receive(:perform_later).with(draft)

        subject
        
        expect(participant_pick_1.reload.cube_card).to eq cube_card
        expect(draft.reload.last_pick_at).to eq participant_pick_1.updated_at
      end
    end
    
    context "when it is the last pick" do
      let!(:old_participant_pick) { create :participant_pick, draft_participant: participant_1, round: draft.rounds - 1, pick_number: 1 }
      let!(:participant_pick) { create :participant_pick, draft_participant: participant_1, cube_card_id: nil, round: draft.rounds, pick_number: draft.rounds * 14 }

      it "does not enqueue a skip job and completes the draft" do
        allow(participant_1).to receive(:draft).and_return(draft)
        expect(draft).not_to receive(:enqueue_skip_job)
        expect(SkipActiveParticipantJob).not_to receive(:set)

        subject

        expect(participant_pick.reload.cube_card).to eq cube_card
        expect(draft.reload.status).to eq DraftStatus.completed
      end
    end

    context 'when participant is skipped' do
      let!(:participant_1) { create :draft_participant, draft: draft, draft_position: 1, skipped: true }
      let!(:participant_pick_1) do
        create :participant_pick,
        draft_participant_id: participant_1.id,
        cube_card_id: nil,
        round: 1,
        pick_number: 1,
        skipped: true
      end

      it 'after pick participant is no longer skipped' do
        subject

        expect(participant_pick_1.reload.cube_card).to eq cube_card
        expect(participant_pick_1.skipped).to eq false
        expect(participant_1.skipped?).to be false
      end

      context 'when participant is behind multiple picks' do
        let!(:participant_pick_2) do
          create :participant_pick,
          draft_participant_id: participant_1.id,
          cube_card_id: nil,
          round: 2,
          pick_number: 28,
          skipped: true
        end
        let!(:participant_pick_3) do
          create :participant_pick,
          draft_participant_id: participant_14.id,
          round: 3,
          pick_number: 42
        end

        it 'after pick participant is still skipped' do
          subject

          expect(participant_pick_1.reload.cube_card).to eq cube_card
          expect(participant_pick_1.skipped).to eq false
          expect(participant_1.skipped?).to be true
        end
      end
    end
  end

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
