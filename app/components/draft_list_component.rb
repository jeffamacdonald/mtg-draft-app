# frozen_string_literal: true

class DraftListComponent < ViewComponent::Base
  def initialize(user:)
    user_draft_ids = user.drafts.select(:id)
    @pending_drafts = Draft.pending.where.not(id: user_draft_ids)
    @active_drafts = user.drafts
    @spectator_drafts = Draft.active.where.not(id: user_draft_ids)
  end
end
