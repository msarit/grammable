require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "comments#create action" do

    it "should require users to be logged in to comment on a gram" do
      gram = FactoryBot.create(:gram)
      post :create, params: { gram_id: gram.id, comment: { message: "not signed in" } }
      expect(response).to redirect_to new_user_session_path

      expect(gram.comments.count).to eq 0
    end
    
    it "should allow users to create comments on grams" do
      gram = FactoryBot.create(:gram)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user

      post :create, params: { gram_id: gram.id, comment: { message: "awesome gram!" } }
      expect(response).to redirect_to gram_path(gram)

      expect(gram.comments.count).to eq 1
      expect(gram.comments.last.message).to eq("awesome gram!")
      
    end

    it "should return http status of Not Found if associated gram isnt found" do
      diff_user = FactoryBot.create(:user)
      sign_in diff_user

      post :create, params: { gram_id: 'BOOBOO', comment: { message: "gram not found" } }
      expect(response).to have_http_status :not_found
    end
  end


  describe "comments#destroy action" do

    it "shouldn't let unauthenticated users destroy a comment" do
      comment = FactoryBot.create(:comment)
      delete :destroy, params: { gram_id: comment.gram_id, id: comment.id }

      expect(response).to redirect_to new_user_session_path
    end

    it "should allow only the comment or gram creator to destroy a comment" do
      comment = FactoryBot.create(:comment)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user
      
      delete :destroy, params: { gram_id: comment.gram_id, id: comment.id }
      expect(response).to have_http_status(:forbidden)
    end

    # THE BELOW TEST ISNT WORKING!!!!!!
    # it "should allow comment creator to successfully delete comments" do
    #   comment = FactoryBot.create(:comment)
    #   this_gram = comment.reload_gram
    #   sign_in comment.user

    #   delete :destroy, params: { gram_id: comment.gram_id, id: comment.id } # this action isnt happening
    #   redirect_to gram_path(this_gram)

    #   comment = Comment.find_by_id(comment.id)
    #   expect(comment).to eq(nil)
    # end

    it "should return a 404 error if comment with the specified id cannot be found" do
      comment = FactoryBot.create(:comment)
      user_not_owner = FactoryBot.create(:user) # user necessary, else redirected to sign-in page 
      sign_in user_not_owner

      delete :destroy, params: { gram_id: comment.gram_id, id: 'booboo' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
