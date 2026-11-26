# frozen_string_literal: true

module Drafts
  # Skips a pick (and its drafter) whose timer ran out. Does nothing unless the pick is
  # still the active one.
  class SkipActivePick
    def self.call(participant_pick:)
      new(participant_pick:).call
    end

    def initialize(participant_pick:)
      @participant_pick = participant_pick
      @draft = participant_pick.draft
    end

    # As in MakePick: change state under the draft's row lock, then email and enqueue.
    def call
      return unless draft.with_lock { skip }

      email_next_participant
      Broadcast::DraftUpdateJob.perform_later(draft)
      draft.enqueue_skip_job
      draft.active_pick&.enqueue_auto_pick_job # nil when the final pick was skipped
    end

    private

    attr_reader :participant_pick, :draft

    def draft_participant
      participant_pick.draft_participant
    end

    def skip
      return false unless draft.active_pick == participant_pick

      draft_participant.reload.update!(skipped: true)
      participant_pick.update!(skipped: true)
      draft.record_pick!(participant_pick)
      draft.update!(last_pick_at: draft_participant.reload.updated_at)
      true
    end

    def email_next_participant
      next_participant = draft.active_participant
      return if next_participant.nil? || next_participant == draft_participant

      PickMailer.skipped_email(draft_participant, next_participant.user).deliver_now
    end
  end
end
