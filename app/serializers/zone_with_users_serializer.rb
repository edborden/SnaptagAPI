class ZoneWithUsersSerializer < ApplicationSerializer
	attributes :lat, :lon, :range, :active
	has_many :users, embed_in_root: true

	def users
		if scope
			users = object.users.delete scope
		else
			object.users
		end
	end

end
