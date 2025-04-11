class TransferPortalTransactionFormComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(sender:, receiver:)
    @sender = sender
    @receiver = receiver
    @draft = sender.draft
  end

  private

  attr_reader :sender, :receiver, :draft

  def sender_picks
    sender.participant_picks.includes(:cube_card).order(:pick_number)
  end

  def receiver_picks
    receiver.participant_picks.includes(:cube_card).order(:pick_number)
  end

  def pick_checkbox(pick, owner)
    check_box_tag "#{owner}_participant_pick_ids[]", 
                  pick.id, 
                  false, 
                  id: "#{owner}_pick_#{pick.id}",
                  class: "peer hidden",
                  data: {
                    action: "change->transfer-portal#updateSubmitButton",
                    transfer_portal_target: "#{owner}Pick"
                  }
  end

  def pick_label(pick, owner)
    label_tag "#{owner}_pick_#{pick.id}", 
              class: "block p-2 border rounded cursor-pointer hover:bg-gray-50 peer-checked:border-blue-500 peer-checked:bg-blue-50" do
      content_tag(:div, pick.display_name, class: "font-medium")
    end
  end
end