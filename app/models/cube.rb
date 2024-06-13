# t.references :user, references: :users, foreign_key: { to_table: :users}
# t.string :name, null: false
# t.timestamps null: false

class Cube < ApplicationRecord
  belongs_to :owner, foreign_key: :user_id, class_name: "User"
  has_many :cube_cards
  has_many :cards, :through => :cube_cards

  has_one_attached :import_file
end
