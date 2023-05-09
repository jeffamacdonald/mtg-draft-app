class CreateCubes < ActiveRecord::Migration[7.0]
  def change
    create_table :cubes do |t|
      t.references :user, references: :users, foreign_key: { to_table: :users}
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :cubes, :name
  end
end
