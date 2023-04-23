class ChangeBookmarksSchema < ActiveRecord::Migration[6.1]
  def change
    change_column_null :bookmarks, :comment_id, true
    change_column_null :bookmarks, :hack_id, true
  end
end
