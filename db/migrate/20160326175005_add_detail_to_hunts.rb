class AddDetailToHunts < ActiveRecord::Migration
  def change
    add_column :hunts, :detail, :string
  end
end
