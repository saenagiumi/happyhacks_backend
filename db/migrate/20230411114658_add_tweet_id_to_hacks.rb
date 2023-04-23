class AddTweetIdToHacks < ActiveRecord::Migration[6.1]
  def change
    add_column :hacks, :tweet_id, :string
  end
end
