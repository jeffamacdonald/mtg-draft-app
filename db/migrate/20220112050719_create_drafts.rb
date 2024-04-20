class CreateDrafts < ActiveRecord::Migration[7.0]
  def change
    create_table :drafts, id: :uuid do |t|
      t.references :cube, references: :cubes, foreign_key: { to_table: :cubes }, type: :uuid
      t.references :user, references: :users, foreign_key: { to_table: :users }, type: :uuid
      t.string :name, null: false
      t.integer :rounds, null: false
      t.integer :timer_minutes
      t.string :status, null: false
      t.timestamps null: false
    end

    add_index :drafts, :name
    add_index :drafts, :status
  end
end
