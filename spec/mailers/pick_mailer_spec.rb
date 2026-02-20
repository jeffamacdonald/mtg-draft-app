require 'rails_helper'

RSpec.describe PickMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:draft) { create(:draft, owner: user, name: 'Test Draft') }
  let(:draft_participant) { create(:draft_participant, draft: draft, user: user) }
  let(:cube_card) { create(:cube_card, cube: draft.cube) }
  let(:participant_pick) { create(:participant_pick, draft_participant: draft_participant, cube_card: cube_card) }

  describe '#next_up_email' do
    let(:mail) { PickMailer.next_up_email(participant_pick, user) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq("You're up in Test Draft")
    end

    it 'sends to the correct user' do
      expect(mail.to).to eq([user.email])
    end

    it 'displays correct body message' do
      expect(mail.body.encoded).to include("#{draft_participant.display_name} just picked #{cube_card.card.name}.")
    end
  end

  describe '#skipped_email' do
    let(:skipped_participant) { create(:draft_participant, draft: draft) }
    let(:mail) { PickMailer.skipped_email(skipped_participant, user) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq("You're up in Test Draft")
    end

    it 'sends to the correct user' do
      expect(mail.to).to eq([user.email])
    end

    it 'displays correct body message' do
      expect(mail.body.encoded).to include("#{skipped_participant.display_name} has been skipped.")
    end
  end

  describe '#queued_pick_taken_email' do
    let(:mail) { PickMailer.queued_pick_taken_email(participant_pick, user) }

    it 'sets the correct subject' do
      expect(mail.subject).to eq("You're next pick was taken!")
    end

    it 'sends to the correct user' do
      expect(mail.to).to eq([user.email])
    end

    it 'displays correct body message' do
      expect(mail.body.encoded).to include("#{draft_participant.display_name} picked #{cube_card.card.name}.")
    end
  end
end
