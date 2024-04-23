class CreateCubeCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cube_cards, id: :uuid do |t|
      t.references :cube, references: :cubes, foreign_key: { to_table: :cubes}, type: :uuid
      t.references :card, references: :cards, foreign_key: { to_table: :cards}, type: :uuid
      t.integer :count, null: false
      t.string :custom_set, null: false
      t.string :custom_image, null: false
      t.string :custom_color_identity, array: true, null: false
      t.integer :custom_cmc, null: false
      t.boolean :soft_delete, default: false
      t.timestamps null: false
    end

    add_index :cube_cards, :soft_delete
    add_index :cube_cards, :custom_color_identity
    add_index :cube_cards, [:cube_id, :card_id], unique: true
  end
end
