require 'rails_helper'

RSpec.describe "Learnings", type: :request do
  # Use let! to ensure records are created before each example in the describe block
  let!(:learning1) { create(:learning, title: "Ruby Basics", tags: "ruby, basics", learned_on: Date.today - 2.days) }
  let!(:learning2) { create(:learning, title: "Rails Intro", tags: "rails, ruby, web", learned_on: Date.today - 1.day) }
  let!(:learning3) { create(:learning, title: "CSS Fun", tags: "css, web", learned_on: Date.today) }

  describe "GET /learnings" do
    it "returns http success and displays all learnings" do
      get learnings_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(learning1.title)
      expect(response.body).to include(learning2.title)
      expect(response.body).to include(learning3.title)
      expect(response.body).to include("Filter by Tag:")
      expect(response.body).to include("rails") # Check if tags are displayed
    end

    context "when filtering by tag" do
      it "displays only learnings with the specified tag" do
        get learnings_path(tag: "ruby")
        expect(response).to have_http_status(:success)
        expect(response.body).to include(learning1.title)
        expect(response.body).to include(learning2.title)
        expect(response.body).not_to include(learning3.title)
        expect(response.body).to include("Clear filter")
      end

      it "displays only learnings with a different specified tag" do
        get learnings_path(tag: "css")
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include(learning1.title)
        expect(response.body).not_to include(learning2.title)
        expect(response.body).to include(learning3.title)
        expect(response.body).to include("Clear filter")
      end

      it "handles tags that don't exist" do
        get learnings_path(tag: "nonexistent")
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include(learning1.title)
        expect(response.body).not_to include(learning2.title)
        expect(response.body).not_to include(learning3.title)
        expect(response.body).to include("No learnings found matching your filter")
        expect(response.body).to include("Clear filter")
      end
    end
  end

  describe "GET /learnings/new" do
    it "returns http success" do
      get new_learning_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /learnings" do
    context "with valid parameters" do
      let(:valid_attributes) { { title: "New Valid Learning", body: "Content here", tags: "new, valid", learned_on: Date.today } }

      it "creates a new Learning" do
        expect {
          post learnings_path, params: { learning: valid_attributes }
        }.to change(Learning, :count).by(1)
      end

      it "redirects to the learnings index" do
        post learnings_path, params: { learning: valid_attributes }
        expect(response).to redirect_to(learnings_path)
        expect(flash[:notice]).to eq("Learning logged successfully.")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { title: "", body: "", tags: "invalid", learned_on: Date.today } }

      it "does not create a new Learning" do
        expect {
          post learnings_path, params: { learning: invalid_attributes }
        }.to change(Learning, :count).by(0)
      end

      it "re-renders the 'new' template" do
        post learnings_path, params: { learning: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE /learnings/multiple" do
    it "deletes the selected learnings" do
      learnings_to_delete = [ learning1, learning3 ]
      expect {
        delete destroy_multiple_learnings_path, params: { learning_ids: learnings_to_delete.map(&:id) }
      }.to change(Learning, :count).by(-2)
    end

    it "redirects to the learnings index with a notice" do
      learnings_to_delete = [ learning1, learning3 ]
      delete destroy_multiple_learnings_path, params: { learning_ids: learnings_to_delete.map(&:id) }
      expect(response).to redirect_to(learnings_path)
      expect(flash[:notice]).to include("2 learnings deleted successfully.")
    end

    it "handles deleting no learnings" do
      expect {
        delete destroy_multiple_learnings_path, params: { learning_ids: [] }
      }.to change(Learning, :count).by(0)
      expect(response).to redirect_to(learnings_path)
      expect(flash[:notice]).to include("0 learnings deleted successfully.")
    end

     it "handles deleting non-existent learnings gracefully" do
      expect {
        delete destroy_multiple_learnings_path, params: { learning_ids: [ learning1.id, 9999 ] } # 9999 doesn't exist
      }.to change(Learning, :count).by(-1) # Only learning1 is deleted
      expect(response).to redirect_to(learnings_path)
      expect(flash[:notice]).to include("1 learning deleted successfully.")
    end
  end
end
