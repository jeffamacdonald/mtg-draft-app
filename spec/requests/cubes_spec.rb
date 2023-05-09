require 'rails_helper'

RSpec.describe "Cubes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/cubes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/cubes/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/cubes/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/cubes/new"
      expect(response).to have_http_status(:success)
    end
  end

end
