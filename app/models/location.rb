class Location < ActiveRecord::Base
	belongs_to :user

	def self.create_from_client(user,params)
		create! do |location|
			location.user_id = user.id
			location.latitude = params[:latitude]
			location.longitude = params[:longitude]
			location.accuracy = params[:accuracy]
			location.timestamp = params[:timestamp]
		end
	end

	#def push_location_update_request
	#	Pusher.trigger(self.user.token, 'updatelocation', {message:"updatelocation"}) if self.locationrequests.count == 1
	#end

	#def clear_locationrequests
	#	locationrequests.destroy_all
	#end

end