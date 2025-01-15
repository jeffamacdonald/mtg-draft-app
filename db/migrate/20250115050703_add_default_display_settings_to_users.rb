class AddDefaultDisplaySettingsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :default_display, :string, null: false, default: "image"
    add_column :users, :default_image_size, :string, null: false, default: "lg"
  end
end
