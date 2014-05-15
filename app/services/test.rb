class Test

	def web
#		ed = User.find_by(name: "Ed")
		queue = Activationqueue.create
		11.times { Fabricate(:user_with_location,activationqueue_id: queue.id) }
		25.times { Fabricate(:active_test_user) }
	end
	
end
