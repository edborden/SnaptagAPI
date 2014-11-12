class Location < ActiveRecord::Base
	belongs_to :user

	after_create :push_create

	def push_create
		json_package = LocationSerializer.new self
		Pusher.trigger user.id, 'location', json_package
	end

end