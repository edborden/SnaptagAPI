class AddActivationqueueIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activationqueue_id, :integer
    add_index :users, :activationqueue_id
  end
end
