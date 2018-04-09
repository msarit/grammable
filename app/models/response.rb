class Response < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  validates :message, presence: true
end
