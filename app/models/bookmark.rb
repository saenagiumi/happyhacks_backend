class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :comment, optional: true
  belongs_to :hack, optional: true

  validates :comment_id, uniqueness: { scope: :user_id }, allow_nil: true
  validates :hack_id, uniqueness: { scope: :user_id }, allow_nil: true
end