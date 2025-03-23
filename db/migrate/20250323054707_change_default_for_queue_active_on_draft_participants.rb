class ChangeDefaultForQueueActiveOnDraftParticipants < ActiveRecord::Migration[7.1]
  def change
    change_column_default :draft_participants, :queue_active, from: true, to: false
  end
end
