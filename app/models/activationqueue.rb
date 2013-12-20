class Activationqueue < ActiveRecord::Base
	has_many :users

def full?
		return true if users_count == 12
	end

end
