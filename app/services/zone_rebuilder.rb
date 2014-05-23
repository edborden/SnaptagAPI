require 'geo_calc'

class ZoneRebuilder

	def initialize(zone=nil)
		@z = zone
	end

	def run
	# TO REBUILD A ZONE, RESET RANGE.
		@z.range = DEFAULT_MAX_DISTANCE
	# GET LIST OF USERS NOT IN ZONE.
		users_not_in_zone = get_users_not_in_zone(@z.users,@z)
	# CREATE ZONE AROUND ONE RANDOM USER, JOIN THEM, GET NEW LIST OF USERS NOT IN THE NEW ZONE.
		until users_not_in_zone.empty?
			random_user = users_not_in_zone.shuffle.first
			random_zone = Zone.new(lat:random_user.locations.first.lat,lon:random_user.locations.first.lon,grow_id:random_user.id)
			new_zone = GeoCalc::compute_containing_zone(@z,random_zone)
			get_users_not_in_zone(users_not_in_zone,new_zone)
	# KEEP CHECKING THE REST OF THE USERS AND GROWING THE ZONE UNTIL THEY ARE ALL CONTAINED.
		end
		@z.lat = new_zone.lat
		@z.lon = new_zone.lon
		@z.range = new_zone.range
		@z.save
		return @z
	end

	def get_users_not_in_zone(list,zone)
		response = []
		list.each do |user|
			response += [user] if !zone.contains?(user.lat,user.lon)
		end
		return response
	end
end