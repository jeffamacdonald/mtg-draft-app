class PickMailer < ApplicationMailer
  def next_up_email(participant_pick, user)
    @participant_pick = participant_pick
    # TODO: allow phone number
    mail(to: user.email, subject: "You're up in #{participant_pick.draft.name}")
  end

  def skipped_email(skipped_participant, user)
    @skipped_participant = skipped_participant
    mail(to: user.email, subject: "You're up in #{skipped_participant.draft.name}")
  end
end
