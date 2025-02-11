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
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "jeff#{n}@example.com" }
    password  { "123456" }
    sequence(:username) { |n| "jeff#{n}" }
    phone { "5555555555" }
    secret_key { "test_secret" }
  end
end
