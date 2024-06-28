require 'rails_helper'

RSpec.describe HealthController, type: :request do
  describe "GET #index" do
    it 'returns a successful response' do
      get up_path
      expect(response).to be_successful
    end
  end
end
