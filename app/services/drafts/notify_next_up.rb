# frozen_string_literal: true

module Drafts
  # Emails whoever is on the clock after a pick. Returns false if the email failed to
  # send (the pick is already saved, so failures are logged rather than raised).
  class NotifyNextUp
    def self.call(pick:, except_user:)
      new(pick:, except_user:).call
    end

    def initialize(pick:, except_user:)
      @pick = pick
      @except_user = except_user
    end

    def call
      # No next user once the draft's final pick is made
      next_user = pick.draft.reload.active_participant&.user
      return true if next_user.nil? || next_user == except_user

      deliver(next_user)
    end

    private

    attr_reader :pick, :except_user

    def deliver(user)
      PickMailer.next_up_email(pick, user).deliver_now
      true
    rescue StandardError => e
      Rails.logger.error("Next-up email failed: #{e.class}: #{e.message}")
      false
    end
  end
end
