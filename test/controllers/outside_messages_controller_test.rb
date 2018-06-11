require 'test_helper'

class OutsideMessagesControllerTest < ActionDispatch::IntegrationTest

  test "should get contact" do
		get new_outside_message_path
		assert_response :success
	end
end
