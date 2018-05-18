require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "will be invalid without a message" do
    comment = FactoryBot.build(:comment, message: "")

    expect(comment).not_to be_valid
  end
end
