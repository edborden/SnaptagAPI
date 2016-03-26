class ZoneSerializer < ApplicationSerializer
	attributes :lat, :lng, :range, :active
  has_many :hunts, embed_in_root: true

  ## want to show full range of where zones are able to grow to
  def range
    object.range + DEFAULT_MAX_DISTANCE
  end

end
