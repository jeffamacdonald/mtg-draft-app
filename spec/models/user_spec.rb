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
