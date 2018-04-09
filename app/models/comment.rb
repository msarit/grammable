class Comment < ApplicationRecord
  belongs_to :gram
  belongs_to :user

  has_many :responses, :dependent => :delete_all

  validates :message, presence: true
end
