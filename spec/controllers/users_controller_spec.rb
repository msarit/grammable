require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "show#users action" do
    it "should render http status 'Not Found' if the specified user id doesn't exist" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end 
  end
end
