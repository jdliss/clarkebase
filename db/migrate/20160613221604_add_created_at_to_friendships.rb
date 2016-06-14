class AddCreatedAtToFriendships < ActiveRecord::Migration
  def change
    add_column(:friendships, :created_at, :datetime)
    add_column(:friendships, :updated_at, :datetime)
  end
end
