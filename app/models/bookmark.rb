class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :hack, optional: true

  validates :hack_id, uniqueness: { scope: :user_id }, allow_nil: true
end