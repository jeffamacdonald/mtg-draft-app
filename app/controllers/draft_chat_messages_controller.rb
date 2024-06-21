class DraftChatMessagesController < ApplicationController
  def create
    DraftChatMessage.create(create_params)
  end

  private

  def create_params
    params.require(:draft_chat_message).permit(
      :draft_id,
      :text
    ).merge(user: current_user)
  end
end
