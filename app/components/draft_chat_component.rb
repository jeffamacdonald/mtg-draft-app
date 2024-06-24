# frozen_string_literal: true

class DraftChatComponent < ViewComponent::Base
  attr_reader :draft, :draft_chat_messages

  def initialize(draft:, draft_chat_messages:)
    @draft = draft
    @draft_chat_messages = draft_chat_messages
  end

  def messages_from_today?(messages)
    messages.first.created_at.to_date == Date.today
  end
end
