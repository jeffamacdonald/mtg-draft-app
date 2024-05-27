class DraftChannel < ApplicationCable::Channel
  def subscribed
    if params[:id].present?
      @draft = Draft.find(params[:id])
    end

    stream_for @draft
  end

  def unsubscribed
    stop_all_streams
  end
end
