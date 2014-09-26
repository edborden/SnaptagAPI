class User < ActiveRecord::Base
	belongs_to :activationqueue, counter_cache: true
	belongs_to :zone
	has_one :session

	has_many :locations, after_add: :increment_influence

	validates :facebookid, uniqueness: true

	scope :active, -> {where.not(zone_id: nil).where(activationqueue_id: nil)}

	has_many :hunts, -> { where active: true }, foreign_key: "hunter_id"
	has_many :targets, through: :hunts, source: :target
	has_many :flights, -> { where active: true }, class_name: "Hunt", foreign_key: "target_id"
	has_many :hunters, through: :flights, source: :hunter
	scope :need_hunters, -> { where("hunters_count < 3").active.where(activationqueue_id: nil).order(hunters_count: :asc) }
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
		self.zone= Zone.determine_zone_for(lat,lon) || Zone.create_or_grow(self)
		self.activated_at = Time.now
		save
	end

	def increment_influence location
		increment! :influence
	end

	def token
		session.present? ? session.token : nil
	end

	def suspects
		suspects = receivers + givers
	end

	def disavow
		# WHERE DOES THE INFLUENCE GO?
		increment!(:disavowed_count)
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
	end

	def remove_nonhunt_web
		nonhunt_webs = allwebs.select { |web| !web.matching_hunt }
		nonhunt_webs[0].destroy
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
			user.birthday = profile["birthday"]
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

	def lon
		locations.last.lon
	end

	def flat
		locations.first.lat
	end

	def flon
		locations.first.lon
	end

end
