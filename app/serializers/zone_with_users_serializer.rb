class ZoneWithUsersSerializer < ApplicationSerializer
	attributes :lat, :lon, :range, :active
	has_many :users, embed_in_root: true

	def users
		if current_user
			users = object.users -= [current_user]
		else
			object.users
		end
	end

end
