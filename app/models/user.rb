class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :activationqueue

  has_many :hunts, :foreign_key => "hunter_id"
  has_many :targets, :through => :hunts, :source => :target
  has_many :flights, :class_name => "Hunt", :foreign_key => "target_id"
  has_many :hunters, :through => :flights, :source => :hunter

  scope :need_hunters, -> { where("hunters_count < 3").where(active: true).where(activationqueue_id: nil) }
  scope :need_targets, -> { where("targets_count < 3").where(active: true).where(activationqueue_id: nil) }

  counter_culture :activationqueue

  def is_not_already_hunting?(target)
    true if self.targets.reload.include?(target) == false
  end

end
