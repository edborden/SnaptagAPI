class User < ActiveRecord::Base
	belongs_to :activationqueue, counter_cache: true

	has_many :locations

	validates :facebookid, uniqueness: true

	scope :active, -> {where(active: true)}

	has_many :hunts, -> { where active: true }, :foreign_key => "hunter_id"
	has_many :targets, :through => :hunts, :source => :target
	has_many :flights, -> { where active: true }, :class_name => "Hunt", :foreign_key => "target_id"
	has_many :hunters, :through => :flights, :source => :hunter
	scope :need_hunters, -> { where("hunters_count < 3").active.where(activationqueue_id: nil).order(hunters_count: :asc) }
	scope :need_targets, -> { where("targets_count < 3").active.where(activationqueue_id: nil).order(targets_count: :asc) }

	has_many :webs, :foreign_key => "giver_id"
	has_many :receivers, :through => :webs, :source => :receiver
	has_many :antiwebs, :class_name => "Web", :foreign_key => "receiver_id"
	has_many :givers, :through => :antiwebs, :source => :giver
	scope :need_givers, ->(id) { where("givers_count < 6").where("receivers_count < 6").active.where(activationqueue_id: nil).where.not(id: id).order(givers_count: :asc) }
	scope :need_receivers, ->(id) { where("givers_count < 6").where("receivers_count < 6").active.where(activationqueue_id: nil).where.not(id: id).order(receivers_count: :asc) }

	def allwebs_count
		self.givers_count + self.receivers_count
	end

	def allwebs
		allwebs = self.webs + self.antiwebs
	end

	def activate
		self.active = true
		save
	end

	def disavow
		# WHERE DOES THE INFLUENCE GO?
		self.increment!(:disavowed_count)
		deactivate
	end

	def deactivate
		#THIS CAUSES WAY TOO MANY DATABASE WRITES THRU MINUS_ONE'S
		hunts.destroy_all
		flights.destroy_all
		webs.destroy_all
		antiwebs.destroy_all
		self.active = false
		save
	end

	def remove_nonhunt_web
		nonhunt_webs = allwebs.select { |web| !web.matching_hunt }
		nonhunt_webs[0].destroy
	end

	def active?
		true if self.active
	end

	def set_token(token)
		self.token = token
		save
	end

	def self.create_from_facebook(token,profile)
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

	def latest_location
		self.locations.last
	end

end
