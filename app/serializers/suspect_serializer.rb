class SuspectSerializer < ApplicationSerializer
	attributes :name, :targets_found_count, :found_count, :stalkers_exposed_count, :exposed_count, :stealth, :smallpic, :mediumpic, :largepic
	has_many :locations, embed_in_root: true

	# include locations if the user is a target
	def filter(keys)
		keys.delete :locations unless scope.targets.include?(object)
		keys
	end
end
