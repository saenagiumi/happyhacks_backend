class Post < ApplicationRecord
  belongs_to :user

  scope :default_order, -> { order(id: :desc) }

  has_many :comments, dependent: :destroy
end
