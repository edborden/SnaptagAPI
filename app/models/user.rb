class User < ActiveRecord::Base
  belongs_to :activationqueue, counter_cache: true

  has_many :hunts, :foreign_key => "hunter_id"
  has_many :targets, :through => :hunts, :source => :target
  has_many :flights, :class_name => "Hunt", :foreign_key => "target_id"
  has_many :hunters, :through => :flights, :source => :hunter

  scope :need_hunters, -> { where("hunters_count < 3").where(active: true).where(activationqueue_id: nil) }
  scope :need_targets, -> { where("targets_count < 3").where(active: true).where(activationqueue_id: nil) }

  def self.from_mobile(facebookid,token)
    find_by(facebookid: facebookid) || create_from_facebook(token)
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(token)
  end

  def exchange_token
    oauth ||= Koala::Facebook::OAuth.new(726528350693125, "96ec2c1f6e53d6d1b4607164c190109c")
    newtoken = oauth.exchange_access_token(self.token)
    self.token=newtoken
    self.save
    return newtoken
  end

  def self.create_from_facebook(token)
    profile = Koala::Facebook::API.new(token).get_object("me")
    create! do |user|
      user.facebookid = profile["id"]
      user.firstname = profile["firstname"]
      user.lastname = profile["lastname"]
      user.token = testuserhash["access_token"]
      user.email = profile["email"]
      user.gender = profile["gender"]
    end
  end

end
