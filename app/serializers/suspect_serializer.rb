class SuspectSerializer < UserSerializer
	# include locations if the user is a target
	def filter(keys)
		keys.delete :locations unless scope.targets.include?(object)
		keys
	end
end
