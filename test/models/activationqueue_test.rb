require 'test_helper'

class ActivationqueueTest < ActiveSupport::TestCase

	test "queues cannot have no users or inactive users" do
	end

	test "users in queue should not have any relationships" do
	end

	test "create" do
	end

	test "activationqueue runs blastoff when full" do
		activationqueue = Activationqueue.create
		12.times {Fabricate(:user)}
		Blastoff.expects(:new).with(User.all).returns(stub(:run))
		User.all.each do |user|
			activationqueue.users<<(user)
		end
		assert_not Activationqueue.exists?
	end

end
