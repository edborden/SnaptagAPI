class Activationqueue < ActiveRecord::Base
	has_many :users

	private

	def full?
		return true if users_count == 12
	end

end
