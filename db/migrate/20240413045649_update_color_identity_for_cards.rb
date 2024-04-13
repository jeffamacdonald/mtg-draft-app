class UpdateColorIdentityForCards < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :color_identity
    add_column :cards, :color_identity, :string, array: true, null: false
  end
end
