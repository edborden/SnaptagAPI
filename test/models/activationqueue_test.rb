require 'test_helper'

class ActivationqueueTest < ActiveSupport::TestCase

	def setup
		@queue = Activationqueue.create
	end


	test "users_count works" do
		user = Fabricate(:user)
		assert_equal 0,@queue.users.size
		@queue.users<<user
		assert_equal 1,@queue.users.size
	end

	test "queue runs blastoff when full" do
		12.times {Fabricate(:user)}
		Blastoff.expects(:new).returns(stub(:run))
		User.all.each do |user|
			@queue.users<<(user)
		end
		assert_not Activationqueue.exists?
	end

end
