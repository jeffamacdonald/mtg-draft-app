# == Schema Information
#
# Table name: cubes
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_cubes_on_name     (name)
#  index_cubes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Cube < ApplicationRecord
  belongs_to :owner, foreign_key: :user_id, class_name: "User"
  has_many :cube_cards
  has_many :cards, :through => :cube_cards

  has_one_attached :import_file
end
