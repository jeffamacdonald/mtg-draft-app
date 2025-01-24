# t.string :email,              null: false, default: ""
# t.string :encrypted_password, null: false, default: ""
# t.string :username
# t.string :phone
# t.string   :reset_password_token
# t.datetime :reset_password_sent_at
# t.string :default_display, null: false, default: "image"
# t.string :default_image_size, null: false, default: "lg"
# t.string :pick_list_size, null: false, default: ""
# t.timestamps null: false

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
