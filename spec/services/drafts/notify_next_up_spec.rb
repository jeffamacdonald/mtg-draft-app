require 'rails_helper'

RSpec.describe Drafts::NotifyNextUp do
  let(:draft) { create :draft }
  let(:picker) { create :draft_participant, draft: }
  let(:next_drafter) { create :draft_participant, draft: }
  let!(:pick) { create :participant_pick, draft_participant: picker, pick_number: 1 }
  let(:delivery) { double("MessageDelivery", deliver_now: true) }

  subject(:result) { described_class.call(pick:, except_user: picker.user) }

  context "when someone else is on the clock" do
    let!(:next_pick) { create :participant_pick, draft_participant: next_drafter, cube_card: nil, pick_number: 2 }

    it "emails them" do
      expect(PickMailer).to receive(:next_up_email).with(pick, next_drafter.user).and_return(delivery)

      expect(result).to eq true
    end

    it "returns false when the email fails" do
      allow(PickMailer).to receive(:next_up_email).and_raise(StandardError, "mail down")

      expect(result).to eq false
    end
  end

  context "when the excluded user is on the clock" do
    let!(:next_pick) { create :participant_pick, draft_participant: picker, cube_card: nil, pick_number: 2 }

    it "does not email" do
      expect(PickMailer).not_to receive(:next_up_email)

      expect(result).to eq true
    end
  end

  context "after the final pick" do
    it "does not email or fail" do
      expect(PickMailer).not_to receive(:next_up_email)

      expect(result).to eq true
    end
  end
end
