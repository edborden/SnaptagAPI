class Activationqueue < ActiveRecord::Base
	has_many :users, after_add: :blastoff_if_full
	belongs_to :zone

	def blastoff_if_full user = nil
		if users(true).size == 12
			Blastoff.new(users).run
			users.clear
			destroy
		end
	end

	def remove_user user
		users.delete user
		destroy if users(true).blank?
	end

end