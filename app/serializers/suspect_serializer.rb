class SuspectSerializer < ApplicationSerializer
	attributes :name, :exposed_count, :counteract_count, :disavowed_count, :compromised_count, :influence#, :smallpic, :mediumpic, :largepic
	#has_many :locations, embed_in_root: true

	# include locations if the user is a target
	#def locations
	#	scope.targets.include?(object) ? object.locations : []
	#end
end
