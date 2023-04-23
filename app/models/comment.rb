class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  scope :default_order, -> { order(id: :desc) }
  
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user
end