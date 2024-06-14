class RemoveUniqueIndexFromCubeCard < ActiveRecord::Migration[7.1]
  def change
    remove_index :cube_cards, [:cube_id, :card_id], unique: true
  end
end
