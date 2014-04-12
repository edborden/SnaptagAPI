class Test

	def web
		ed = User.find_by(lastname: "Borden")
		user1 = User.create(firstname: "test1firstname", lastname: "test1lastname", facebookid: 1,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user2 = User.create(firstname: "test2firstname", lastname: "test2lastname", facebookid: 2,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user3 = User.create(firstname: "test3firstname", lastname: "test3lastname", facebookid: 3,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user4 = User.create(firstname: "test4firstname", lastname: "test4lastname", facebookid: 4,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user5 = User.create(firstname: "test5firstname", lastname: "test5lastname", facebookid: 5,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user6 = User.create(firstname: "test6firstname", lastname: "test6lastname", facebookid: 6,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user7 = User.create(firstname: "test7firstname", lastname: "test7lastname", facebookid: 7,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user8 = User.create(firstname: "test8firstname", lastname: "test8lastname", facebookid: 8,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user9 = User.create(firstname: "test9firstname", lastname: "test9lastname", facebookid: 9,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user10 = User.create(firstname: "test10firstname", lastname: "test10lastname", facebookid: 10,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		user11 = User.create(firstname: "test11firstname", lastname: "test11lastname", facebookid: 11,smallpic: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg", mediumpic: "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg", largepic: "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg", active:true)
		Web.create(giver_id: ed.id, receiver_id:user1.id)
		Web.create(giver_id: ed.id, receiver_id:user2.id)
		Web.create(giver_id: ed.id, receiver_id:user3.id)
		Web.create(giver_id: ed.id, receiver_id:user4.id)
		Web.create(giver_id: ed.id, receiver_id:user5.id)
		Web.create(giver_id: ed.id, receiver_id:user6.id)
		Web.create(giver_id: user7.id, receiver_id:ed.id)
		Web.create(giver_id: user8.id, receiver_id:ed.id)
		Web.create(giver_id: user9.id, receiver_id:ed.id)
		Web.create(giver_id: user10.id, receiver_id:ed.id)
		Web.create(giver_id: user11.id, receiver_id:ed.id)
	end
end
