class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards, id: :uuid do |t|
      t.string :name, null: false
      t.string :cost
      t.integer :cmc, null: false
      t.string :color_identity, array: true, null: false
      t.string :type_line, null: false
      t.string :card_text
      t.string :layout
      t.integer :power
      t.integer :toughness
      t.string :default_image, null: false
      t.string :default_set, null: false
      t.timestamps null: false
    end

    add_index :cards, :name, unique: true
    add_index :cards, :cmc
    add_index :cards, :card_text
    add_index :cards, :power
    add_index :cards, :toughness
    add_index :cards, :color_identity
  end
end
