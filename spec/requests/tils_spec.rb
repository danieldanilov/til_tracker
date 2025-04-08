require 'rails_helper'

RSpec.describe "Tils", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/tils/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/tils/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/tils/create"
      expect(response).to have_http_status(:success)
    end
  end

end
