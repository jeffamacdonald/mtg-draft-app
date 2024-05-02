class AddDefaultSkippedToDraftParticipant < ActiveRecord::Migration[7.0]
  def change
    change_column_default :draft_participants, :skipped, from: nil, to: false
  end
end
