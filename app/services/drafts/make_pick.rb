# frozen_string_literal: true

module Drafts
  # Fills a participant's next open pick with a card and advances the draft.
  class MakePick
    # Raised when the request is out of date: the pick it was meant for has already been
    # made, or the participant is neither on the clock nor skipped.
    class StalePick < StandardError; end

    # participant_pick_id is the pick the caller intends to fill
    def self.call(draft_participant:, cube_card:, participant_pick_id:)
      new(draft_participant:, cube_card:, participant_pick_id:).call
    end

    def initialize(draft_participant:, cube_card:, participant_pick_id:)
      @draft_participant = draft_participant
      @participant_pick_id = participant_pick_id
      @cube_card = cube_card
      @draft = draft_participant.draft
    end

    # Database changes happen under the draft's row lock. Jobs are enqueued after it is
    # released, so workers never see uncommitted picks.
    def call
      draft.with_lock { make_pick }

      if @starts_next_turn
        draft.enqueue_skip_job
        draft.active_pick.enqueue_auto_pick_job
      end
      RemoveQueuedPicksJob.perform_later(pick)
      Broadcast::DraftUpdateJob.perform_later(draft)
      pick
    end

    private

    attr_reader :draft_participant, :cube_card, :participant_pick_id, :draft, :pick

    def make_pick
      draft_participant.reload # it may have been skipped while we waited for the lock
      @pick = draft_participant.next_open_pick
      raise StalePick unless pick && pick.id == participant_pick_id && may_pick?

      pick.update!(cube_card:, skipped: false)
      draft.record_pick!(pick)

      if draft_participant.skipped?
        catch_up_skipped_participant
      else
        advance_draft
      end
    end

    # Otherwise the card would fill a later pick and jump the draft past other players
    def may_pick?
      draft_participant.skipped? || draft.active_participant == draft_participant
    end

    # A skipped participant rejoins once their next open pick is still to come
    def catch_up_skipped_participant
      next_round = draft_participant.next_open_pick&.round || draft.rounds + 1
      if draft.last_pick_number < draft_participant.calculate_pick_number(next_round)
        draft_participant.update!(skipped: false)
      end
    end

    def advance_draft
      draft.update!(last_pick_at: pick.updated_at)

      if pick.pick_number == draft.participants_count * draft.rounds
        draft.completed!
      else
        @starts_next_turn = true
      end
    end
  end
end
