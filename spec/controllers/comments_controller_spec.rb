require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "comments#create action" do
    
    it "should allow users to create comments on grams" do
      gram = FactoryBot.create(:gram)
      diff_user = FactoryBot.create(:user)
      sign_in diff_user

      post :create, params: { gram_id: gram.id, comment: { message: "awesome gram!" } }
      expect(response).to redirect_to root_path

      expect(gram.comments.length).to eq 1
      expect(gram.comments.last.message).to eq "awesome gram!"
      
    end

    it "should require users to be logged in to comment on a gram" do
      gram = FactoryBot.create(:gram)
      post :create, params: { gram_id: gram.id, comment: { message: "not signed in" } }
      expect(response).to redirect_to new_user_session_path

      # expect(gram.comments.last.message).to eq nil
    end

    it "should return http status of 404 Not Found if the gram isnt found" do
      diff_user = FactoryBot.create(:user)
      sign_in diff_user

      post :create, params: { gram_id: 'BOOBOO', comment: { message: "gram not found" } }
      expect(response).to have_http_status :not_found
    end
  end

end
