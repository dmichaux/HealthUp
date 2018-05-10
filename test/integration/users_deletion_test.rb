require 'test_helper'

class UsersDeletionTest < ActionDispatch::IntegrationTest
  
	def setup
		@user_admin = users(:adam)
		@user 			= users(:beth)
	end

  test "must be admin to delete user" do
		log_in_as @user
		assert_not @user.admin?
		assert_no_difference "User.count" do
			delete user_path @user_admin
		end
		assert_redirected_to root_path
	end

	test "successful user deletion" do
		log_in_as @user_admin
		assert @user_admin.admin?
		assert_difference "User.count", -1 do
			delete user_path @user
		end
		assert_redirected_to users_path
		assert_not flash.empty?
	end
end
