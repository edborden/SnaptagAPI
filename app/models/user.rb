class User < ActiveRecord::Base
	belongs_to :activationqueue, counter_cache: true

	validates :facebookid, uniqueness: true

	has_many :hunts, -> { where active: true }, :foreign_key => "hunter_id"
	has_many :targets, :through => :hunts, :source => :target
	has_many :flights, -> { where active: true }, :class_name => "Hunt", :foreign_key => "target_id"
	has_many :hunters, :through => :flights, :source => :hunter
	scope :need_hunters, -> { where("hunters_count < 3").where(active: true).where(activationqueue_id: nil).order(hunters_count: :asc) }
	scope :need_targets, -> { where("targets_count < 3").where(active: true).where(activationqueue_id: nil).order(targets_count: :asc) }

	has_many :webs, :foreign_key => "giver_id"
	has_many :receivers, :through => :webs, :source => :receiver
	has_many :antiwebs, :class_name => "Web", :foreign_key => "receiver_id"
	has_many :givers, :through => :antiwebs, :source => :giver
	scope :need_givers, ->(id) { where("givers_count < 6").where("receivers_count < 6").where(active: true).where(activationqueue_id: nil).where.not(id: id).order(givers_count: :asc) }
	scope :need_receivers, ->(id) { where("givers_count < 6").where("receivers_count < 6").where(active: true).where(activationqueue_id: nil).where.not(id: id).order(receivers_count: :asc) }

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

	def deactivate
		destroy_all_hunts
		destroy_all_webs
		self.active = false
		#destroy all webs
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

	def disavow
		self.disavowed_count.increment!
		deactivate
	end

	def compromise
		self.compromised_count.increment!
		deactivate
	end
end
