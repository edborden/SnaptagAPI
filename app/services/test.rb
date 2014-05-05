class Test

	def web
		ed = User.find_by(lastname: "Borden")
		11.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		Web.create(giver_id: ed.id, receiver_id:@user0.id)
		Web.create(giver_id: ed.id, receiver_id:@user1.id)
		Web.create(giver_id: ed.id, receiver_id:@user2.id)
		Web.create(giver_id: ed.id, receiver_id:@user3.id)
		Web.create(giver_id: ed.id, receiver_id:@user4.id)
		Web.create(giver_id: ed.id, receiver_id:@user5.id)
		Web.create(giver_id: @user6.id, receiver_id:ed.id)
		Web.create(giver_id: @user7.id, receiver_id:ed.id)
		Web.create(giver_id: @user8.id, receiver_id:ed.id)
		Web.create(giver_id: @user9.id, receiver_id:ed.id)
		Web.create(giver_id: @user10.id, receiver_id:ed.id)
	end
end
