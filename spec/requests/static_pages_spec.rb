require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  # Reason: Removed test for old root_path which was static_pages#home
  # describe "GET / (root)" do
  #   it "returns http success" do
  #     get root_path
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe "GET /hire-me" do
    it "returns http success" do
      get hire_me_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_path
      expect(response).to have_http_status(:success)
    end
  end
end
