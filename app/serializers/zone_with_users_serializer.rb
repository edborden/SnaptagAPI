class ZoneWithUsersSerializer < ApplicationSerializer
	attributes :lat, :lng, :range, :active
	has_many :users, embed_in_root: true

	def users
		scope ? users = object.users - [scope] : object.users
	end

end
