class AddHunterCountAndTargetCountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :huntercount, :integer
  	add_column :users, :targetcount, :integer
  end
end
