class AddTradeFlagToDrafts < ActiveRecord::Migration[7.1]
  def change
    add_column :drafts, :transfers_allowed, :boolean
  end
end
