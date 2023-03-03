class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :sub, null: false
      t.string :picture
      t.string :name
      t.string :email
      t.timestamps
    end

    add_index :users, :sub, unique: true
  end
end
