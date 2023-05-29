# frozen_string_literal: true

class DraftListComponent < ViewComponent::Base
  def initialize(user:)
    @pending_drafts = Draft.pending - user.drafts
    @active_drafts = user.drafts
  end
end
