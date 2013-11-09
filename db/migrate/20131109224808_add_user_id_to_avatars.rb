class AddUserIdToAvatars < ActiveRecord::Migration
  def change
    add_column :avatars, :user_id, :integer
    add_index :avatars, :user_id
  end
end
