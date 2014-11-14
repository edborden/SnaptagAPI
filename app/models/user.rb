class User < ActiveRecord::Base
	acts_as_messageable
	belongs_to :activationqueue, counter_cache: true
	belongs_to :zone
	has_one :session

	has_many :locations, after_add: :increment_stealth

	validates :facebookid, uniqueness: true

	scope :active, -> {where.not(zone_id: nil).where(activationqueue_id: nil)}

	has_many :hunts, -> { where active: true }, foreign_key: "stalker_id"
	has_many :targets, through: :hunts, source: :target
	has_many :flights, -> { where active: true }, class_name: "Hunt", foreign_key: "target_id"
	has_many :stalkers, through: :flights, source: :stalker
	scope :need_stalkers, -> { where("stalkers_count < 3").active.where(activationqueue_id: nil).order(stalkers_count: :asc) }
	scope :need_targets, -> { where("targets_count < 3").active.where(activationqueue_id: nil).order(targets_count: :asc) }

	has_many :webs, foreign_key: "giver_id"
	has_many :receivers, through: :webs, source: :receiver
	has_many :antiwebs, class_name: "Web", foreign_key: "receiver_id"
	has_many :givers, through: :antiwebs, source: :giver
	# I don't need to pass an ID in here, do I? Just reference self.id directly
	scope :need_givers, ->(id) { where("givers_count < 6").where("receivers_count < 6").active.where.not(id: id).order(givers_count: :asc) }
	scope :need_receivers, ->(id) { where("givers_count < 6").where("receivers_count < 6").active.where.not(id: id).order(receivers_count: :asc) }

	def allwebs_count
		self.givers_count + self.receivers_count
	end

	def allwebs
		allwebs = webs + antiwebs
	end

	def activate
		self.zone= Zone.determine_zone_for(lat,lng) || Zone.create_or_grow(self)
		self.activated_at = Time.now
		save
	end

	def increment_stealth location
		#location doesn't get used, but must handle getting passed in automatically
		increment! :stealth
	end

	def token
		session.present? ? session.token : nil
	end

	def suspects
		suspects = receivers + givers
	end

	def expose_self
		# WHERE DOES THE STEALTH GO?
		increment!(:exposed_count)

		# notify stalkers
		body = "Your target, " + self.name + ", exposed themselves."
		stalkers.each do |stalker|
			stalker.notify "Target removed",body,self
			json_package = NotificationSerializer.new stalker.first_notif, scope:stalker
			Pusher.trigger stalker.id,'notification',json_package
		end

		# notify self
		body = "You've been removed from the game."
		notify "Exposed self",body,nil
		json_package = NotificationSerializer.new first_notif, scope:self
		Pusher.trigger self.id,'notification',json_package		
		
		deactivate
	end

	def deactivate
		#THIS CAUSES WAY TOO MANY DATABASE WRITES THRU MINUS_ONE'S
		zone.remove_user(self)
		hunts.destroy_all
		flights.destroy_all
		webs.destroy_all
		antiwebs.destroy_all
		locations.destroy_all
		Pusher.trigger self.id, "remove", self.id
	end

	def remove_nonhunt_web
		nonhunt_webs = allwebs.select { |web| !web.matching_hunt }
		nonhunt_web = nonhunt_webs.first
		Pusher.trigger nonhunt_web.giver.id, 'remove_suspect', nonhunt_web.receiver.id
		Pusher.trigger nonhunt_web.receiver.id, 'remove_suspect', nonhunt_web.giver.id
		nonhunt_web.destroy
	end

	def active
		self.zone_id.present?
	end

	def self.create_from_facebook(token,profile)
		pichash = Facebook.new(token).get_pics
		create! do |user|
			user.facebookid = profile["id"]
			user.name = profile["first_name"]
			user.email = profile["email"]
			user.gender = profile["gender"]
			#user.birthday = profile["birthday"]
			user.smallpic = pichash[:smallpic]
			user.mediumpic = pichash[:mediumpic]
			user.largepic = pichash[:largepic]
		end
	end

	def status
		if self.activationqueue_id
			return "queue" 
		elsif active
			return "active"
		else 
			return "inactive"
		end
	end

	def lat
		locations.last.lat
	end

	def lng
		locations.last.lng
	end

	def flat
		locations.first.lat
	end

	def flng
		locations.first.lng
	end

	def first_notif
		mailbox.notifications.first
	end

end
