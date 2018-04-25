require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

	def setup
		@site_name = "Website Name"
	end

	test "should get home" do
		get root_path
		assert_response :success
		assert_select "title", "#{@site_name}"
	end

	test "should get help" do
		get help_path
		assert_response :success
		assert_select "title", "Help | #{@site_name}"
	end
end
