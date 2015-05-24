class VersionsController < ApplicationController

	def index
		versions = Version.all
		render json: versions
	end

end