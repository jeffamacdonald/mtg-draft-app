class AddPickListSizeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pick_list_size, :string, null: false, default: ""
  end
end
