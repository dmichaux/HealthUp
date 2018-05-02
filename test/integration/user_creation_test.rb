require 'test_helper'

class UserCreationTest < ActionDispatch::IntegrationTest

	def setup
		@user_admin = users(:adam)
		@user 			= users(:beth)
	end

	test "non-admin cannot create new user" do
		log_in_as @user
		get new_user_path
		assert_response :redirect
		assert_no_difference "User.count" do
			post users_path params: { user: { name: "TestName",
																				email: "testing@example.com" } }
		end
	end

	test "invalid user creation information" do
		log_in_as @user_admin
		get new_user_path
		assert_template "users/new"
		assert_no_difference "User.count" do
			post users_path params: { user: { name: "",
																			 email: "" } }
		end
	end

	test "valid user creation" do
		log_in_as @user_admin
		get new_user_path
		assert_difference "User.count", 1 do
			post users_path params: { user: { name: "TestName",
																				email: "testing@example.com" } }
		end
	end
end
