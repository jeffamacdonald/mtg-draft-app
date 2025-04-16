# == Schema Information
#
# Table name: drafts
#
#  id                :uuid             not null, primary key
#  last_pick_at      :datetime
#  name              :string           not null
#  rounds            :integer          not null
#  status            :string           not null
#  timer_minutes     :integer
#  transfers_allowed :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cube_id           :uuid
#  user_id           :uuid
#
# Indexes
#
#  index_drafts_on_cube_id  (cube_id)
#  index_drafts_on_name     (name)
#  index_drafts_on_status   (status)
#  index_drafts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cube_id => cubes.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Draft do
  describe '#set_participant_positions!' do
    let!(:draft) { create :draft }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: nil }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: nil }

    subject { draft.set_participant_positions! }

    before do
      allow_any_instance_of(Array).to receive(:shuffle).and_return([draft_participant_2, draft_participant_1])
    end

    it 'participant positions are randomized' do
      expect(draft_participant_1).to receive(:update).with(draft_position: 2)
      expect(draft_participant_2).to receive(:update).with(draft_position: 1)
      subject
    end
  end

  describe "#setup_picks!" do
    let!(:draft) { create :draft, rounds: 2 }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: 1 }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2 }

    it "creates empty picks based on draft position" do
      expect {
        draft.setup_picks!
      }.to change(ParticipantPick, :count).by 4
      expect(ParticipantPick.find_by(round: 1, pick_number: 1).draft_participant).to eq draft_participant_1
      expect(ParticipantPick.find_by(round: 1, pick_number: 2).draft_participant).to eq draft_participant_2
      expect(ParticipantPick.find_by(round: 2, pick_number: 3).draft_participant).to eq draft_participant_2
      expect(ParticipantPick.find_by(round: 2, pick_number: 4).draft_participant).to eq draft_participant_1
    end
  end

  describe "#active_pick" do
    let(:draft) { create :draft }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: 1 }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2 }
    let!(:draft_participant_3) { create :draft_participant, draft_id: draft.id, draft_position: 3 }
    let!(:participant_pick_1) do
      create :participant_pick,
        draft_participant_id: draft_participant_1.id,
        round: 1,
        pick_number: 1,
        cube_card_id: nil
    end
    let!(:participant_pick_2) do
      create :participant_pick,
        draft_participant_id: draft_participant_2.id,
        round: 1,
        pick_number: 2,
        cube_card_id: nil
    end
    let!(:participant_pick_3) do
      create :participant_pick,
        draft_participant_id: draft_participant_3.id,
        round: 1,
        pick_number: 3,
        cube_card_id: nil
    end

    it "returns the active pick" do
      expect(draft.active_pick).to eq participant_pick_1
    end
  end

  describe '#active_participant' do
    let(:draft) { create :draft }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: 1 }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2 }
    let!(:draft_participant_3) { create :draft_participant, draft_id: draft.id, draft_position: 3 }
    let!(:participant_pick_1) do
      create :participant_pick,
        draft_participant_id: draft_participant_1.id,
        round: 1,
        pick_number: 1,
        cube_card_id: nil
    end
    let!(:participant_pick_2) do
      create :participant_pick,
        draft_participant_id: draft_participant_2.id,
        round: 1,
        pick_number: 2,
        cube_card_id: nil
    end
    let!(:participant_pick_3) do
      create :participant_pick,
        draft_participant_id: draft_participant_3.id,
        round: 1,
        pick_number: 3,
        cube_card_id: nil
    end

    subject { draft.active_participant }

    context 'when no picks have been made' do
      it 'draft position one is active drafter' do
        expect(subject).to eq draft_participant_1
      end
    end

    context 'when picks have been made' do
      let(:draft) { create :draft }
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

      it 'drafter with pick_number 3 as next pick is active' do
        expect(subject).to eq draft_participant_3
      end

      context 'multiple drafters are skipped' do
        let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2, skipped: true }
        let!(:draft_participant_3) { create :draft_participant, draft_id: draft.id, draft_position: 3, skipped: true }
        let!(:participant_pick_3) do
          create :participant_pick,
            draft_participant_id: draft_participant_3.id,
            round: 1,
            pick_number: 3,
            cube_card_id: nil,
            skipped: true
        end
        let!(:participant_pick_4) do
          create :participant_pick,
            draft_participant_id: draft_participant_3.id,
            round: 2,
            pick_number: 4,
            cube_card_id: nil,
            skipped: true
        end
        let!(:participant_pick_5) do
          create :participant_pick,
            draft_participant_id: draft_participant_2.id,
            round: 2,
            pick_number: 5,
            cube_card_id: nil,
            skipped: true
        end
        let!(:participant_pick_6) do
          create :participant_pick,
            draft_participant_id: draft_participant_1.id,
            round: 2,
            pick_number: 6,
            cube_card_id: nil
        end

        it 'active drafter is the first that is not skipped' do
          expect(subject).to eq draft_participant_1
        end
      end
    end
  end

  describe "#last_pick_number" do
    let(:draft) { create :draft }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: 1 }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2 }
    let!(:participant_pick_1) do
      create :participant_pick,
        draft_participant_id: draft_participant_1.id,
        round: 1,
        pick_number: 1,
        cube_card_id: nil
    end
    let!(:participant_pick_2) do
      create :participant_pick,
        draft_participant_id: draft_participant_2.id,
        round: 1,
        pick_number: 2,
        cube_card_id: nil
    end

    context "when no picks have been made" do
      it "returns 0" do
        expect(draft.last_pick_number).to eq 0
      end
    end

    context "when picks have been made" do
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
          draft_participant_id: draft_participant_2.id,
          round: 2,
          pick_number: 3
      end

      it "returns last picked participant pick number" do
        expect(draft.last_pick_number).to eq 3
      end

      context "when drafter is skipped" do
        let!(:participant_pick_4) do
          create :participant_pick,
            draft_participant_id: draft_participant_1.id,
            round: 2,
            pick_number: 4,
            cube_card_id: nil,
            skipped: true
        end

        it "returns the skipped pick number" do
          expect(draft.last_pick_number).to eq 4
        end
      end
    end
  end

  describe "#timer_live?" do
    let(:timer_minutes) { nil }
    let(:draft) { create :draft, timer_minutes: timer_minutes, status: DraftStatus.active }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: 1 }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2 }
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
        draft_participant_id: draft_participant_2.id,
        round: 2,
        pick_number: 3
    end
    let!(:participant_pick_4) do
      create :participant_pick,
        draft_participant_id: draft_participant_1.id,
        round: 2,
        pick_number: 4,
        cube_card_id: nil
    end

    context "when timer minutes is nil" do
      it "returns false" do
        expect(draft.timer_live?).to eq false
      end
    end

    context "when timer minutes is present" do
      let(:timer_minutes) { 300 }

      context "when current round is 2 or less" do
        it "returns false" do
          expect(draft.timer_live?).to eq false
        end
      end

      context "when current round is greater than 2" do
        let!(:participant_pick_4) do
          create :participant_pick,
            draft_participant_id: draft_participant_1.id,
            round: 2,
            pick_number: 4
        end
        let!(:participant_pick_5) do
          create :participant_pick,
            draft_participant_id: draft_participant_1.id,
            round: 3,
            pick_number: 5,
            cube_card_id: nil
        end

        it "returns true" do
          expect(draft.timer_live?).to eq true
        end

        context "when draft is completed" do
          before do
            draft.completed!
          end

          it "returns false" do
            expect(draft.timer_live?).to eq false
          end
        end
      end
    end
  end

  describe "#enqueue_skip_job" do
    let(:draft) { create :draft, status: DraftStatus.active }
    let!(:draft_participant_1) { create :draft_participant, draft_id: draft.id, draft_position: 1 }
    let!(:draft_participant_2) { create :draft_participant, draft_id: draft.id, draft_position: 2 }
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
        draft_participant_id: draft_participant_2.id,
        round: 2,
        pick_number: 3
    end
    let!(:participant_pick_4) do
      create :participant_pick,
        draft_participant_id: draft_participant_1.id,
        round: 2,
        pick_number: 4,
        cube_card_id: nil
    end

    context "when timer is not live" do
      it "does nothing" do
        expect(SkipActiveParticipantJob).not_to receive(:perform_later)
        draft.enqueue_skip_job
      end
    end

    context "when timer is live" do
      let!(:participant_pick_4) do
        create :participant_pick,
          draft_participant_id: draft_participant_1.id,
          round: 2,
          pick_number: 4
      end
      let!(:participant_pick_5) do
        create :participant_pick,
          draft_participant_id: draft_participant_2.id,
          round: 3,
          pick_number: 5,
          cube_card_id: nil
      end

      before do
        draft.update(last_pick_at: participant_pick_4.created_at)
      end

      it "enqueues job at target end time" do
        freeze_time do
          expect_any_instance_of(TimerCalculator).to receive(:calculate_target_end).and_return(10.seconds.from_now)
          expect(SkipActiveParticipantJob).to receive(:set).with(wait: 10).and_call_original
          expect_any_instance_of(ActiveJob::ConfiguredJob).to receive(:perform_later).with(participant_pick_5)

          draft.enqueue_skip_job
        end
      end
    end
  end
end
