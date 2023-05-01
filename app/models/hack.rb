# == Schema Information
#
# Table name: hacks
#
#  id         :bigint           not null, primary key
#  body       :text
#  category   :string
#  tags       :string           default([]), is an Array
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tweet_id   :string
#  user_id    :bigint           not null
#
# Indexes
#
#  index_hacks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Hack < ApplicationRecord
  belongs_to :user

  scope :default_order, -> { order(id: :desc) }

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user
end
