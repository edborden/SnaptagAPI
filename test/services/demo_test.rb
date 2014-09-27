require 'test_helper'

class DemoTest < ActiveSupport::TestCase

	test "create_activation_queue_around" do

		
		Demo.new.create_activationqueue_around params[:location][:lat].to_f,params[:location][:lon].to_f
	end

end