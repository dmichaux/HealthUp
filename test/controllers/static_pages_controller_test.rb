require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

	def setup
		@site_name = "HealthUp"
	end

	test "should get home" do
		get root_path
		assert_response :success
		assert_select "title", "#{@site_name}"
	end

	test "should get about" do
		get about_path
		assert_response :success
		assert_select "title", "About | #{@site_name}"
	end
end
