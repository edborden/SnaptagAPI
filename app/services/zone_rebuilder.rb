require 'geo_calc'

class ZoneRebuilder

	def initialize(zone=nil)
		@z = zone
	end

	def run
	# TO REBUILD A ZONE, FIRST RESET.
		@z.range = DEFAULT_MAX_DISTANCE
		@z.grow_id = nil
	# GET LIST OF USERS NOT IN ZONE.
		users_not_in_zone = get_users_not_in_zone(@z.users,@z)
	# CREATE ZONE AROUND ONE RANDOM USER, JOIN THEM, GET NEW LIST OF USERS NOT IN THE NEW ZONE.
		until users_not_in_zone.empty?
			random_user = users_not_in_zone.shuffle.first
			random_zone = Zone.new(lat:random_user.flat,lng:random_user.flng,grow_id:random_user.id)
			new_zone = GeoCalc::compute_containing_zone(@z,random_zone)
			users_not_in_zone = get_users_not_in_zone(users_not_in_zone,new_zone)
	# KEEP CHECKING THE REST OF THE USERS AND GROWING THE ZONE UNTIL THEY ARE ALL CONTAINED.
		end
		unless new_zone
			@z.save 
		else
			@z.lat = new_zone.lat
			@z.lng = new_zone.lng
			@z.range = new_zone.range
			@z.grow_id = random_user.id
			@z.save
		end
		return @z
	end

	def get_users_not_in_zone(list,zone)
		response = []
		list.each do |user|
			response += [user] unless zone.contains?(user.locations.first.lat,user.locations.first.lng)
		end
		return response
	end
end