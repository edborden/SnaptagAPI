class RemoveTypeFromRelationships < ActiveRecord::Migration
  def change
  	remove_column :relationships, :type, :string
  	add_column :relationships, :relationship_type, :string
  end
end
