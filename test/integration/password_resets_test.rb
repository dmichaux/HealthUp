require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:adam)
	end

	test "password reset with invalid email" do
		get new_password_reset_path
		assert_template "password_resets/new"
		post password_resets_path params: { password_reset: { email: "" }}
		assert_equal 0, ActionMailer::Base.deliveries.size
		assert_template "password_resets/new"
	end

	test "expired reset token" do
		get new_password_reset_path
		post password_resets_path params: { password_reset: { email: @user.email }}
		user = assigns(:user)
		user.update_attribute(:reset_sent_at, 3.hours.ago)
		patch password_reset_path(user.pass_reset_token),
															params: { email: user.email,
																				user: { password: "newpassword",
																								password_confirmation: "newpassword" }}
		assert_redirected_to new_password_reset_path
		follow_redirect!
		assert_match /expired/i, response.body
	end

	test "password reset procedure" do
		get new_password_reset_path
		# Valid email
		post password_resets_path params: { password_reset: { email: @user.email }}
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_redirected_to root_path
		# Accessing password reset form
		user = assigns(:user)
		# Inactive user
		user.toggle!(:activated)
		get edit_password_reset_path(user.pass_reset_token, email: user.email)
		assert_redirected_to root_path
		user.toggle!(:activated)
		# Correct token, wrong email
		get edit_password_reset_path(user.pass_reset_token, email: "")
		assert_redirected_to root_path
		# Wrong token, correct email
		get edit_password_reset_path("x", email: user.email)
		assert_redirected_to root_path
		# Correct token and email
		get edit_password_reset_path(user.pass_reset_token, email: user.email)
		assert_template "password_resets/edit"
		assert_select "input[name=email][type=hidden][value=?]", user.email
		# Password reset form
		# Invalid password and confirmation
		patch password_reset_path(user.pass_reset_token),
															params: { email: user.email,
																				user: { password: "thesepasswords",
																								password_confirmation: "donotmatch" }}
		assert_template "password_resets/edit"
		# Empty password
		patch password_reset_path(user.pass_reset_token),
															params: { email: user.email,
																				user: { password: "",
																								password_confirmation: "wheresthepass" }}
		assert_template "password_resets/edit"
		# Valid password and confirmation
		patch password_reset_path(user.pass_reset_token),
															params: { email: user.email,
																				user: { password: "newpassword",
																								password_confirmation: "newpassword" }}
		assert is_logged_in?
		assert_nil user.reload.reset_digest
		assert_redirected_to user
	end
end
