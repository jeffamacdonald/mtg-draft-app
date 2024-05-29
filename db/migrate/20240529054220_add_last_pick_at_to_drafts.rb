class AddLastPickAtToDrafts < ActiveRecord::Migration[7.0]
  def change
    add_column :drafts, :last_pick_at, :datetime
  end
end
