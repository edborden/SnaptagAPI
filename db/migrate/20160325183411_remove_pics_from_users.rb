class RemovePicsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :smallpic, :string
    remove_column :users, :largepic, :string
    remove_column :users, :birthday, :string
  end
end
