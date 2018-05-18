require 'rails_helper'

RSpec.describe Gram, type: :model do
  it "will be invalid without a picture" do
    gram = FactoryBot.build(:gram, picture: "")

    expect(gram).not_to be_valid
  end
end
