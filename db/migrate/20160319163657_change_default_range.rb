class ChangeDefaultRange < ActiveRecord::Migration
  def change
    change_column_default(:zones, :range, 2500)
  end
end
