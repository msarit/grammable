require 'rails_helper'

RSpec.describe ResponsesController, type: :controller do
  describe "responses#create action" do

    it "should require users to be logged in to respond to a comment" do
      comment = FactoryBot.create(:comment)
      post :create, params: { gram_id: comment.gram.id, comment_id: comment.id, response: { message: "not signed in" } }
      expect(response).to redirect_to new_user_session_path

      expect(comment.responses.count).to eq(0)
    end
    
    it "should allow users to create comments on grams" do
      comment = FactoryBot.create(:comment)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user

      post :create, params: { gram_id: comment.gram.id, comment_id: comment.id, response: { message: "awesome gram!" } }
      expect(response).to redirect_to gram_path(comment.reload_gram)

      expect(comment.responses.count).to eq 1
      expect(comment.responses.last.message).to eq("awesome gram!")
      
    end

    it "should return http status of Not Found if associated comment isnt found" do
      comment = FactoryBot.create(:comment)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user

      post :create, params: { gram_id: comment.gram.id, comment_id: 'BOOBOO', response: { message: "gram not found" } }
      expect(response).to have_http_status :not_found
    end
  end


  describe "responses#destroy action" do

    it "shouldn't let unauthenticated users destroy a response" do
      aResponse = FactoryBot.create(:response)
      delete :destroy, params: { gram_id: aResponse.comment.gram_id, comment_id: aResponse.comment_id, id: aResponse.id }

      expect(response).to redirect_to new_user_session_path
    end

    it "should allow only the response, comment or gram creator to destroy a response" do
      aResponse = FactoryBot.create(:response)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user
      
      delete :destroy, params: { gram_id: aResponse.comment.gram_id, comment_id: aResponse.comment_id, id: aResponse.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "should allow response creator to successfully delete response" do
      aResponse = FactoryBot.create(:response)
      this_gram = aResponse.comment.reload_gram
      sign_in aResponse.user

      delete :destroy, params: { gram_id: aResponse.comment.gram_id, comment_id: aResponse.comment_id, id: aResponse.id }
      expect(response).to redirect_to gram_path(this_gram)

      response2 = Comment.find_by_id(aResponse.id)
      expect(response2).to eq(nil)
    end

    it "should allow owner of comment responded to successfully delete response" do
      aResponse = FactoryBot.create(:response)
      this_gram = aResponse.comment.reload_gram
      sign_in aResponse.comment.user

      delete :destroy, params: { gram_id: aResponse.comment.gram_id, comment_id: aResponse.comment_id, id: aResponse.id }
      expect(response).to redirect_to gram_path(this_gram)

      response2 = Comment.find_by_id(aResponse.id)
      expect(response2).to eq(nil)
    end

    it "should allow owner of gram with the comment responded to successfully delete response" do
      aResponse = FactoryBot.create(:response)
      this_gram = aResponse.comment.reload_gram
      sign_in aResponse.comment.gram.user

      delete :destroy, params: { gram_id: aResponse.comment.gram_id, comment_id: aResponse.comment_id, id: aResponse.id }
      expect(response).to redirect_to gram_path(this_gram)

      response2 = Comment.find_by_id(aResponse.id)
      expect(response2).to eq(nil)
    end

    it "should return a 404 error if response with the specified id cannot be found" do
      aResponse = FactoryBot.create(:response)
      user_not_owner = FactoryBot.create(:user) # user necessary, else redirected to sign-in page 
      sign_in user_not_owner

      delete :destroy, params: { gram_id: aResponse.comment.gram_id, comment_id: aResponse.comment_id, id: 'booboo' }
      expect(response).to have_http_status(:not_found)
    end
  end

end
