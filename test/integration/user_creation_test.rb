require 'test_helper'

class UserCreationTest < ActionDispatch::IntegrationTest

	def setup
		@user_admin = users(:adam)
		@user 			= users(:beth)
		ActionMailer::Base.deliveries.clear
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
		assert_template "users/new"
	end

	test "valid user creation with account activation" do
		log_in_as @user_admin
		get new_user_path
		assert_difference "User.count", 1 do
			post users_path params: { user: { name: "TestName",
																				email: "testing@example.com" } }
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		# Invalid activation token
		get edit_account_activation_path("bad_token_here", email: user.email)
		assert_not user.activated?
		# Invalid user email
		get edit_account_activation_path(user.activation_token, email: "bad@email.no")
		assert_not user.activated?
		# Valid activation
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		follow_redirect!
		assert_template "users/show"
	end
end
