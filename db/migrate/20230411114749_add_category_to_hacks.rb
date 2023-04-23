class AddCategoryToHacks < ActiveRecord::Migration[6.1]
  def change
    add_column :hacks, :category, :string
  end
end
