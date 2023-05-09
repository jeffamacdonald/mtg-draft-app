# frozen_string_literal: true

class DraftListComponent < ViewComponent::Base
  def initialize(user:)
    @pending_drafts = Draft.pending - user.drafts
    @active_drafts = user.drafts
  end

  def create_new_draft

  end
end
