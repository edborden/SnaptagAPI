class SuspectSerializer < ApplicationSerializer
	attributes :name, :exposed_count, :counteract_count, :disavowed_count, :compromised_count, :influence, :smallpic, :mediumpic, :largepic
	has_many :locations, embed_in_root: true

	# include locations if the user is a target
	def filter(keys)
		keys.delete :locations unless scope.targets.include?(object)
		keys
	end
end
