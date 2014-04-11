class Locationrequest < ActiveRecord::Base
	belongs_to :location

	before_destroy :send_location

	def send_location
		Push.new.locationrequest(self.location)
	end

end