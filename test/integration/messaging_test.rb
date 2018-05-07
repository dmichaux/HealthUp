require 'test_helper'

class MessagingTest < ActionDispatch::IntegrationTest

	def setup
		@user_1 = users(:adam)
		@user_2	= users(:beth)
		log_in_as @user_1
	end

	test "should not display message form if viewing own page" do
		get user_path @user_1
		assert_select "input[value=?]", "Send", count: 0
		assert_select "a[href=?]", messages_user_path(@user_1)
	end

	test "invalid message" do
		get user_path @user_2
		assert_select "input[value=?]", "Send" 
		assert_no_difference "Message.count" do
			post messages_path, params: { message: { to_user_id: @user_2.id,
																							 body: "" } }
		end
		assert_template "users/show"
		assert_select "div#error_explanation"
	end

	test "valid message submission" do
		get user_path @user_2
		assert_difference "Message.count", 1 do
			post messages_path, params: { message: { to_user_id: @user_2.id,
																							 body: "Have a great day!" } }
		end
		assert_redirected_to @user_2
		assert_not flash.empty?
	end
end
