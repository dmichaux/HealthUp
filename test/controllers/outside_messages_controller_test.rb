require 'test_helper'

class OutsideMessagesControllerTest < ActionDispatch::IntegrationTest

  test "should get contact" do
		get contact_path
		assert_response :success
	end
end
