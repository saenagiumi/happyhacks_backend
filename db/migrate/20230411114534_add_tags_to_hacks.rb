class AddTagsToHacks < ActiveRecord::Migration[6.1]
  def change
    add_column :hacks, :tags, :string, array: true, default: []
  end
end
