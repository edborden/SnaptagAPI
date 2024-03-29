class User < ActiveRecord::Base
	acts_as_messageable
	belongs_to :activationqueue, counter_cache: true
	belongs_to :zone
	has_one :session
	has_one :alerter

	has_many :locations, after_add: :increment_stealth

	scope :active, -> {where.not(zone_id: nil).where(activationqueue_id: nil)}

	has_many :hunts, -> { where active: true }, foreign_key: "stalker_id"
	has_many :targets, through: :hunts, source: :target
	has_many :flights, -> { where active: true }, class_name: "Hunt", foreign_key: "target_id"
	has_many :stalkers, through: :flights, source: :stalker
	scope :need_stalkers, -> { active.where("stalkers_count < 3").order(stalkers_count: :asc) }
	scope :need_targets, -> { active.where("targets_count < 3").order(targets_count: :asc) }

	has_many :webs, foreign_key: "giver_id"
	has_many :receivers, through: :webs, source: :receiver
	has_many :antiwebs, class_name: "Web", foreign_key: "receiver_id"
	has_many :givers, through: :antiwebs, source: :giver

	scope :need_givers, -> { active.where("givers_count < 6").where("receivers_count < 6").order(givers_count: :asc) }
	scope :need_receivers, -> { active.where("givers_count < 6").where("receivers_count < 6").order(receivers_count: :asc) }

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
		return self
	end

	def increment_stealth location
		#location doesn't get used, but must handle getting passed in automatically
		increment! :stealth
	end

	def token
		try(:session).try(:token)
	end

	def suspects
		receivers + givers
	end

	def expose_self
		increment!(:exposed_count)

		# notify stalkers
		body = "Your target, " + self.name + ", unsuccessfully tried to counter-tag someone."
		stalkers.each {|stalker| stalker.notify "Target removed",body,self}

		# notify self
		notify "Counter-tag unsuccessful","You've been removed from the game.",nil
		
		# grab zone before deactivate
		#zone = zone

		# deactivate
		deactivate

		# fill hunt holes
		#GameHealer.new(zone).run
	end

	def notify subject,body,object,alert=false
		Mailboxer::Notification.clear_validators!
		receipt = super subject,body,object
		json_package = NotificationSerializer.new receipt.notification, scope:self
		Pusher.trigger "user"+self.id.to_s,'notification',json_package		
		alerter.send_alert subject,body if alerter && alert
	end

	def notify_entered_game
		notify "You have entered the game","Get moving!",nil,true
	end

	def deactivate
		#THIS CAUSES WAY TOO MANY DATABASE WRITES THRU MINUS_ONE'S
		givers.each {|giver| giver.remove_suspect(self)}
		receivers.each {|receiver| receiver.remove_suspect(self)}
		zone.remove_user self
		self.activated_at = nil
		hunts.destroy_all
		flights.destroy_all
		webs.destroy_all
		antiwebs.destroy_all
		locations.destroy_all
	end

	def make_room
		remove_nonhunt_web until reload.allwebs_count < 11
	end

	def remove_nonhunt_web
		nonhunt_web = allwebs.find { |web| !web.matching_hunt }
		nonhunt_web.remove_suspects
		nonhunt_web.destroy
	end

	def remove_suspect suspect
		Pusher.trigger "user"+self.id.to_s, "Suspect removed", suspect.id
	end

	def active
		self.zone_id.present?
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
