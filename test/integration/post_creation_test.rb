require 'test_helper'

class PostCreationTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user 	= users(:adam)
  	@cohort = cohorts(:one)
  	log_in_as @user
  end

  test "must be logged in to create a post" do
  	delete logout_path
  	assert_not is_logged_in?
  	assert_no_difference "Post.count" do
	  	post posts_path, params: { post: { title: "Test",
	  																		 body: "Have a great day!",
	  																		 author_id: @user.id,
	  																		 cohort_id: @cohort.id }}
  	end
  	assert_redirected_to login_path
  end

  test "must be admin to create a post" do
  	@user.toggle!(:admin)
  	assert_not @user.admin?
  	assert_no_difference "Post.count" do
	  	post posts_path, params: { post: { title: "Test",
	  																		 body: "Have a great day!",
	  																		 author_id: @user.id,
	  																		 cohort_id: @cohort.id }}
  	end
  	assert_redirected_to root_path
  end

  test "invalid post title" do
  	assert_no_difference "Post.count" do
	  	post posts_path, params: { post: { title: "",
	  																		 body: "Have a great day!",
	  																		 author_id: @user.id,
	  																		 cohort_id: @cohort.id }}
  	end
  	assert_template "cohorts/show"
		assert_select "div.text-danger"
  end

  test "invalid post body" do
  	assert_no_difference "Post.count" do
	  	post posts_path, params: { post: { title: "Test",
	  																		 body: "",
	  																		 author_id: @user.id,
	  																		 cohort_id: @cohort.id }}
  	end
  	assert_template "cohorts/show"
		assert_select "div.text-danger"
  end

  test "successful post creation" do
  	assert_difference "Post.count", 1 do
	  	post posts_path, params: { post: { title: "Test",
	  																		 body: "Have a great day!",
	  																		 author_id: @user.id,
	  																		 cohort_id: @cohort.id }}
  	end
  	assert_redirected_to cohort_path @cohort
		assert_not flash.empty?
  end

end
