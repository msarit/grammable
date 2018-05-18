require 'rails_helper'

RSpec.describe ResponsesController, type: :controller do
  describe "responses#create action" do

    # it "should require users to be logged in to respond to a comment" do
    #   comment = FactoryBot.create(:comment)
    #   post :create, params: { gram_id: comment.gram.id, comment_id: comment.id, response: { message: "not signed in" } }
    #   expect(response).to redirect_to new_user_session_path

    #   expect(comment.responses.count).to eq(0)
    # end
    
    # it "should allow users to create comments on grams" do
    #   comment = FactoryBot.create(:comment)
    #   diff_user = FactoryBot.create(:user)
    #   sign_in diff_user

    #   post :create, params: { gram_id: comment.gram.id, comment_id: comment.id, response: { message: "awesome gram!" } }
    #   expect(response).to redirect_to gram_path(comment.reload_gram)

    #   expect(comment.responses.count).to eq 1
    #   expect(comment.responses.last.message).to eq("awesome gram!")
      
    # end

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
      
    end

    it "should allow only the response or comment creator to destroy a comment" do
      
    end

    # THE BELOW TEST ISNT WORKING!!!!!!
    # it "should allow response creator to successfully delete comments" do
    #   
    # end

    it "should return a 404 error if response with the specified id cannot be found" do
      
    end
  end

end
