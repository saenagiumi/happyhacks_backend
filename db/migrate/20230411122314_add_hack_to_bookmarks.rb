class AddHackToBookmarks < ActiveRecord::Migration[6.1]
  def change
    add_reference :bookmarks, :hack, null: false, foreign_key: true
  end
end
