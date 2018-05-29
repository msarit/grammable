require 'rails_helper'

RSpec.describe Response, type: :model do
  it "will be invalid without a message" do
    comment_response = FactoryBot.build(:response, message: "")

    expect(comment_response).not_to be_valid
  end
end
