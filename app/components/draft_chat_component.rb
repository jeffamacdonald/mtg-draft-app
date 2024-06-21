# frozen_string_literal: true

class DraftChatComponent < ViewComponent::Base
  attr_reader :draft_chat_messages

  def initialize(draft_chat_messages:)
    @draft_chat_messages = draft_chat_messages
  end

  def draft
    draft_chat_messages.first&.draft
  end
end
