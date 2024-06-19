# frozen_string_literal: true

class DraftListComponent < ViewComponent::Base
  def initialize(user:)
    @pending_drafts = Draft.pending - user.drafts
    @active_drafts = user.drafts
    @spectator_drafts = Draft.active - @active_drafts
  end
end
