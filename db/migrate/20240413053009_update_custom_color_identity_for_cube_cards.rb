class UpdateCustomColorIdentityForCubeCards < ActiveRecord::Migration[7.0]
  def change
    remove_column :cube_cards, :custom_color_identity
    add_column :cube_cards, :custom_color_identity, :string, array: true
  end
end
