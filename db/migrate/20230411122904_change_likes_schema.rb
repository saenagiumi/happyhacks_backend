class ChangeLikesSchema < ActiveRecord::Migration[6.1]
  def change
    change_column_null :likes, :comment_id, true
    change_column_null :likes, :hack_id, true
  end
end
