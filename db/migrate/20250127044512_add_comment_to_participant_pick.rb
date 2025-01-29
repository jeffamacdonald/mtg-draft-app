class AddCommentToParticipantPick < ActiveRecord::Migration[7.1]
  def change
    add_column :participant_picks, :comment, :string, default: ""
  end
end
