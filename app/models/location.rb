class Location < ActiveRecord::Base
	belongs_to :user

	def self.create_from_client(user,params)
		create! do |location|
			location.user_id = user.id
			location.lat = params[:lat]
			location.lon = params[:lon]
		end
	end

end