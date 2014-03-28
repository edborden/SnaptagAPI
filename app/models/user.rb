class User < ActiveRecord::Base
	belongs_to :activationqueue, counter_cache: true

	validates :facebookid, uniqueness: true

	has_many :hunts, :foreign_key => "hunter_id"
	has_many :targets, :through => :hunts, :source => :target
	has_many :flights, :class_name => "Hunt", :foreign_key => "target_id"
	has_many :hunters, :through => :flights, :source => :hunter

	has_many :webs, :foreign_key => "giver_id"
	has_many :recievers, :through => :webs, :source => :receiver
	has_many :antiwebs, :class_name => "Web", :foreign_key => "receiver_id"
	has_many :givers, :through => :antiwebs, :source => :giver

	scope :need_hunters, -> { where("hunters_count < 3").where(active: true).where(activationqueue_id: nil) }
	scope :need_targets, -> { where("targets_count < 3").where(active: true).where(activationqueue_id: nil) }

	def current_targets
		list = []
		self.hunts.where(active: true).each do |hunt|
			list<<hunt.target
		end
		return list
	end

	def current_hunters
		list = []
		self.flights.where(active: true).each do |flight|
			list<<flight.hunter
		end
		return list
	end

	def web
		list = self.current_hunters
		list<<self.current_targets
		list<<self.ringers
		fill_ringers if self.list.count < 11

		return

	end

	def activate
		self.active = true
		save
	end

	def deactivate
		self.active = false
		save
	end

	def active?
		true if self.active
	end

	def set_token(token)
		self.token = token
		save
	end

	def self.create_from_facebook(token)
		profile = Facebook.new(token).get_profile
		pichash = Facebook.new(token).get_pics
		create! do |user|
			user.facebookid = profile["id"]
			user.firstname = profile["first_name"]
			user.lastname = profile["last_name"]
			user.token = token
			user.email = profile["email"]
			user.gender = profile["gender"]
			user.birthday = profile["birthday"]
			user.smallpic = pichash[:smallpic]
			user.mediumpic = pichash[:mediumpic]
			user.largepic = pichash[:largepic]
		end
	end

end
