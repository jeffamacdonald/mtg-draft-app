class CreateCubeCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cube_cards do |t|
      t.references :cube, references: :cubes, foreign_key: { to_table: :cubes}
      t.references :card, references: :cards, foreign_key: { to_table: :cards}
      t.integer :count, null: false
      t.string :custom_set
      t.string :custom_image
      t.string :custom_color_identity
      t.integer :custom_cmc
      t.boolean :soft_delete, null: false
      t.timestamps null: false
    end

    add_index :cube_cards, :soft_delete
    add_index :cube_cards, :custom_color_identity
    add_index :cube_cards, [:cube_id, :card_id], unique: true
  end
end
