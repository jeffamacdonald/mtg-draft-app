# frozen_string_literal: true

class DraftChatComponent < ViewComponent::Base
  attr_reader :draft, :draft_chat_messages

  def initialize(draft:, draft_chat_messages:)
    @draft = draft
    @draft_chat_messages = draft_chat_messages
  end
end
