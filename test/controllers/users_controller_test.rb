require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

	def setup
		@user_admin = users(:adam)
		@user 			= users(:beth)
	end

	test "must be admin to get new" do
		log_in_as @user
		get new_user_path
		assert_response :redirect
		log_in_as @user_admin
		get new_user_path
		assert_response :success
	end

	test "must be admin to get index" do
		log_in_as @user
		get users_path
		assert_response :redirect
		log_in_as @user_admin
		get users_path
		assert_response :success
	end
end
