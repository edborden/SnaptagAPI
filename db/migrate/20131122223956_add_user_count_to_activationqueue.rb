class AddUserCountToActivationqueue < ActiveRecord::Migration
  def change
    add_column :activationqueues, :users_count, :integer
  end
end
