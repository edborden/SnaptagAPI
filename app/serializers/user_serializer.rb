class UserSerializer < ApplicationSerializer
	attributes :targets_found_count, :activated_at, :name, :smallpic, :largepic
	has_many :locations, embed_in_root: true

	def locations
		[object.locations.last]
	end
end