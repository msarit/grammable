require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index # This line triggers an HTTP GET request
      expect(response).to have_http_status(:success)
    end
  end
end

