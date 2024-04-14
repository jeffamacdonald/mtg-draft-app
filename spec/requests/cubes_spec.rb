require 'rails_helper'

RSpec.describe "Cubes", type: :request do
  let(:user) { create :user }

  before do
    sign_in user
  end

  # describe "GET /index" do
  #   it "returns http success" do
  #     get "/cubes"
  #     expect(response.status).to eq 200
  #   end
  # end

  # describe "GET /show" do
  #   it "returns http success" do
  #     get "/cubes/show"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /edit" do
  #   it "returns http success" do
  #     get "/cubes/edit"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /new" do
  #   it "returns http success" do
  #     get "/cubes/new"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
