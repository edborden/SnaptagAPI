class Test

def web
	ed = User.find_by(lastname: "Borden")
	user1 = User.create(firstname: "test1firstname", lastname: "test1lastname", facebookid: 1)
	user2 = User.create(firstname: "test2firstname", lastname: "test2lastname", facebookid: 2)
	user3 = User.create(firstname: "test3firstname", lastname: "test3lastname", facebookid: 3)
	Web.create(giver_id: ed.id, receiver_id:user1.id)
	Web.create(giver_id: ed.id, receiver_id:user2.id)
	Web.create(giver_id: ed.id, receiver_id:user3.id)
end