class ZoneWithUsersSerializer < ApplicationSerializer
	attributes :lat, :lon, :range, :active
	has_many :users, embed_in_root: true
end
