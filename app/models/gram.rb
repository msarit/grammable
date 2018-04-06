class Gram < ApplicationRecord
  belongs_to :user
  validates :message, presence: true
  validates :picture, presence: true
end
