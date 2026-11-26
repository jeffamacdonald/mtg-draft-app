class SkipActiveParticipantJob < ApplicationJob
  queue_as :default

  def perform(participant_pick)
    Drafts::SkipActivePick.call(participant_pick:)
  end
end
