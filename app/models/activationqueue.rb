class Activationqueue < ActiveRecord::Base
	has_many :users, after_add: :blastoff_if_full, after_remove: :destroy_if_empty
	belongs_to :zone

	def blastoff_if_full user = nil
		if full?
			Blastoff.new(users).run
			users.each {|user| user.notify_entered_game}
			users.clear
			destroy
		end
	end

	def push_remove user
	end

	def destroy_if_empty user = nil
		destroy if users(true).empty?
	end

	def full?
		users(true).size == 12
	end

end