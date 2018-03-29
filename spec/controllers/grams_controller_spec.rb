require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index # This line triggers an HTTP GET request to the "index" action
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should successfully show the new gram form" do
      user = User.create(
        email:                  'fakeuser@gmail.com',
        password:               'PassWord',
        password_confirmation:  'PassWord'
        )
      sign_in user

      get :new # This line triggers an HTTP GET request to the "new" action
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should successfully create a new gram in database" do
      user = User.create(
        email:                  'fakeuser@gmail.com',
        password:               'PassWord',
        password_confirmation:  'PassWord'
        )
      sign_in user

      post :create, params: { gram: { message: 'Hello!'} } # This line triggers an HTTP POST request to the "create" action
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = User.create(
        email:                  'fakeuser@gmail.com',
        password:               'PassWord',
        password_confirmation:  'PassWord'
        )
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: ''} }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end

end

