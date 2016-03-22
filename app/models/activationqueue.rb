class Activationqueue < ActiveRecord::Base
	has_many :users, after_add: :blastoff_if_full, after_remove: :destroy_if_empty
	belongs_to :zone

	def blastoff_if_full user = nil
		if full?
			json_package = ActivationqueueSerializer.new self
			Keen.publish 'blastoff', json_package
			cached_users = users.to_a
			zone_id = zone.id
			users.clear
			destroy
			zone = Zone.find zone_id
			GameHealer.new(zone).run
			cached_users.each {|user| user.notify_entered_game}
		end
	end

	def push_remove user
	end

	def destroy_if_empty user = nil
		destroy if users(true).empty?
	end

	def full?
		users(true).size == 4
	end

end