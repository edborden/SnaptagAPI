class HuntSerializer < ApplicationSerializer
	attributes :lat, :lng, :completed_at, :image_id, :was_exposed, :detail
end