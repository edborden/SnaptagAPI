class ZonesController < AuthenticatedController
	skip_before_action :ensure_authenticated_user

	def index
		########
		########
		#Demo.new.zones_controller params[:lat].to_f,params[:lng].to_f
		########
		########
		nearest_zone = Zone.determine_nearest_zone_for params[:lat].to_f,params[:lng].to_f
		# if no zones, render "none"
		unless nearest_zone# && nearest_zone.within_50km_of(params[:lat].to_f,params[:lng].to_f)
			render json: {zones:[]}
		else
		# If it's in an active zone, show me that zone and its users
			if nearest_zone.active
				nearest_zone = [nearest_zone]
				render json: nearest_zone, each_serializer: ZoneWithUsersSerializer, root: 'zones'
		# If it's a queue zone, show it + users, and the next zone, until an active zone is reached or 30 miles
			else
				nearest_zones = [nearest_zone]
				until !nearest_zone.within_50km_of(params[:lat].to_f,params[:lng].to_f) || nearest_zone.active
					nearest_zone = Zone.determine_nearest_zone_for params[:lat].to_f,params[:lng].to_f,nearest_zones
					break unless nearest_zone
					nearest_zones += [nearest_zone] if nearest_zone.within_50km_of(params[:lat].to_f,params[:lng].to_f) || nearest_zone.active
				end
				render json: nearest_zones, each_serializer: ZoneWithUsersSerializer, root: 'zones'
			end
		end
	end

end