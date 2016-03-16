class NotificationSerializer < ApplicationSerializer
  attributes :read, :subject, :body, :created_at, :notified_object_type, :notified_object_id
  has_one :hunt, embed_in_root: true

  def read
    object.is_read?(scope)
  end

  def hunt
    if object.notified_object.try :is_a?, Hunt
      object.notified_object
    else
      nil
    end
  end  
end
