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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:email) { "user@example.com" }
    let(:username) { "something_clever" }

    subject { User.create!(email: email, username: username) }

    context 'when email is invalid' do
      let(:email) { "example.com" }

      it 'raises exception' do
        expect{subject}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when username is not unique' do
      let!(:user) { create :user, username: username }

      it 'raises exception' do
        expect{subject}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
