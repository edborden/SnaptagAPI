class ZoneWithUsersSerializer < ApplicationSerializer
	attributes :lat, :lon, :range, :active
	has_many :users, embed_in_root: true

	def users
		if scope
			users = object.users
			users.delete scope
			users
		else
			object.users
		end
	end

end
