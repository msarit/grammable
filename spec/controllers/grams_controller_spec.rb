require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#destroy action" do

    it "shouldn't allow users who didn't create a gram to destroy it" do
      gram = FactoryBot.create(:gram)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user
      delete :destroy, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a gram" do
      gram = FactoryBot.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow user to successfully delete grams" do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      delete :destroy, params: { id: gram.id }
      redirect_to root_path

      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "should return a 404 error if gram with the specified id cannot be found" do
      user_not_owner = FactoryBot.create(:user) # user necessary, else redirected to sign-in page 
      sign_in user_not_owner
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do

    it "shouldn't allow a user who didn't create a gram to update it" do
      gram = FactoryBot.create(:gram)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user
      patch :update, params: { id: gram.id, gram: { message: 'An Update' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a gram" do
      gram = FactoryBot.create(:gram)
      patch :update, params: { id: gram.id, gram: { message: 'Hello!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update grams" do
      gram = FactoryBot.create(:gram, message: "Initial value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: 'Changed' } }
      expect(response).to redirect_to root_path

      gram.reload
      expect(gram.message).to eq('Changed')
    end

    it "should return a 404 error if gram cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: 'BOOYAH', gram: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram = FactoryBot.create(:gram, message: "Initial Value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)

      gram.reload
      expect(gram.message).to eq("Initial Value")
    end
  end

  describe "grams#edit action" do

    it "shouldn't let a user who did not create the gram edit a gram" do
      gram = FactoryBot.create(:gram)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't allow unauthenticated users access the gram edit form" do
      gram = FactoryBot.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the gram if found" do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'WHAT-WHAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#show action" do
    it "should successfully show the page if the specified gram is found" do
      gram = FactoryBot.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new gram form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, params: { gram: { message: 'Hello!'} }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { gram: { message: 'Hello!'} }
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: ''} }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end

end

