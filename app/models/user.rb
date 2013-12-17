class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :activationqueue
  has_many :relationships
  has_many :relations, :through => :relationships
  has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "relation_id"
  has_many :inverse_relations, :through => :inverse_relationships, :source => :user

  scope :active, -> { where(active: true) }
  scope :need_hunters, -> { where("huntercount < 3") }
  scope :need_targets, -> { where("targetcount < 3") }

end
