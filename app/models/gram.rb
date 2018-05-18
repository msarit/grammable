class Gram < ApplicationRecord
  validates :picture, presence: true

  mount_uploader :picture, PictureUploader
  
  belongs_to :user
  has_many :comments, :dependent => :delete_all
end
