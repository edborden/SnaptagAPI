class Location < ActiveRecord::Base
	belongs_to :user
	has_many :locationrequests, after_add: :push_location_update_request

	after_update :clear_locationrequests

	def push_location_update_request
		Pusher.trigger(self.user_id, 'locationrequest') if self.locationrequests.count == 1
	end

	def clear_locationrequests
		locationrequests.destroy_all
	end

end