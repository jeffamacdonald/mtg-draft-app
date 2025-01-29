class RemoveActiveRoundFromDrafts < ActiveRecord::Migration[7.1]
  def change
    remove_column :drafts, :active_round
  end
end
