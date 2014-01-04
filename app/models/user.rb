class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :activationqueue

  has_many :hunts, :foreign_key => "hunter_id"
  has_many :relations, :through => :relationships
  has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "target_id"
  has_many :inverse_relations, :through => :inverse_relationships, :source => :user

  scope :active, -> { where(active: true) }
  scope :need_hunters, -> { where("hunter_count < 3") }
  scope :need_targets, -> { where("target_count < 3") }

  counter_culture :activationqueue

  def self.list_with_count(hcount,tcount)
    users = User.where(hunter_count:hcount, target_count:tcount)
    users.count
  end  

  def is_not_already_hunting?(target)
  #  if self.relations.include?(target) == false
  #    return true
  #  elseif self.relations.each |user| do {user}

  end  

end
