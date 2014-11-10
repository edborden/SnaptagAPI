class ZoneWithUsersSerializer < ApplicationSerializer
	attributes :lat, :lng, :range, :active
	has_many :users, embed_in_root: true

	# this may be causing zone_id to be wiped if an active user calls zones>index
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
