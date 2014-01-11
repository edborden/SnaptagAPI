class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :activationqueue, counter_cache: true

  has_many :hunts, :foreign_key => "hunter_id"
  has_many :targets, :through => :hunts, :source => :target
  has_many :flights, :class_name => "Hunt", :foreign_key => "target_id"
  has_many :hunters, :through => :flights, :source => :hunter

  scope :need_hunters, -> { where("hunters_count < 3").where(active: true).where(activationqueue_id: nil) }
  scope :need_targets, -> { where("targets_count < 3").where(active: true).where(activationqueue_id: nil) }

  def is_not_already_hunting?(target)
    true if self.targets.reload.include?(target) == false
  end

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

end
