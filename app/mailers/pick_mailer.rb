class PickMailer < ApplicationMailer
  def next_up_email(participant_pick, user)
    @participant_pick = participant_pick
    # TODO: allow phone number
    mail(to: user.email, subject: "You're up in #{participant_pick.draft.name}")
  end
end
