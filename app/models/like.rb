# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint
#  hack_id    :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_comment_id  (comment_id)
#  index_likes_on_hack_id     (hack_id)
#  index_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (hack_id => hacks.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment, optional: true
  belongs_to :hack, optional: true

  validates :comment_id, uniqueness: { scope: :user_id }, allow_nil: true
  validates :hack_id, uniqueness: { scope: :user_id }, allow_nil: true
end
