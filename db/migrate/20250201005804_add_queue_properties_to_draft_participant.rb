class AddQueuePropertiesToDraftParticipant < ActiveRecord::Migration[7.1]
  def change
    add_column :draft_participants, :queue_active, :boolean, null: false, default: true
    add_column :draft_participants, :queue_minute_delay, :integer, null: false, default: 0
  end
end
