require 'rails_helper'

RSpec.describe Response, type: :model do
  it "will be invalid without a message" do
    response = FactoryBot.build(:response, message: "")

    expect(comment).not_to be_valid
  end
end
