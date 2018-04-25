require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "Example User", email: "user@example.com")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "should not be admin" do
		assert_not @user.admin?
	end
end
