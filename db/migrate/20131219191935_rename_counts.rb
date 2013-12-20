class RenameCounts < ActiveRecord::Migration
  def change
  change_table :users do |t|
	  t.rename :huntercount, :hunter_count
	  t.rename :targetcount, :target_count
	end
  end
end
