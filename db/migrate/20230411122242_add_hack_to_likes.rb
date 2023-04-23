class AddHackToLikes < ActiveRecord::Migration[6.1]
  def change
    add_reference :likes, :hack, null: false, foreign_key: true
  end
end
