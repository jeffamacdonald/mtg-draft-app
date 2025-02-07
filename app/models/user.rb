# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default(FALSE)
#  default_display        :string           default("image"), not null
#  default_image_size     :string           default("lg"), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  phone                  :string
#  pick_list_size         :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :secret_key

  has_many :cubes
  has_many :draft_participants
  has_many :drafts, :through => :draft_participants
  # validates :username, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false, format: { with: /\A[a-zA-Z0-9_]+\z/ }
  validate :validate_secret_key

  private

  def validate_secret_key
    unless secret_key == ENV.fetch("REGISTRATION_SECRET")
      errors.add(:secret_key, "is invalid")
    end
  end
end
