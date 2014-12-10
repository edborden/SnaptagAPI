class Activationqueue < ActiveRecord::Base
	has_many :users, after_add: [:blastoff_if_full,:push_add], after_remove: [:push_remove,:destroy_if_empty]
	belongs_to :zone

	def blastoff_if_full user = nil
		if full?
			Blastoff.new(users).run
			users.clear
			destroy
		end
	end

	def push_add user
		Pusher.trigger "activationqueue"+self.id.to_s,"add_user",user
	end

	def push_remove user
		Pusher.trigger "activationqueue"+self.id.to_s,"remove_user",user
	end

	def destroy_if_empty user = nil
		destroy if users(true).empty?
	end

	def full?
		users(true).size == 12
	end

end