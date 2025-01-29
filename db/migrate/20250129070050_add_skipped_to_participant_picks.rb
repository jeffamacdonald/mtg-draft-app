class AddSkippedToParticipantPicks < ActiveRecord::Migration[7.1]
  def change
    add_column :participant_picks, :skipped, :boolean, default: false
  end
end
