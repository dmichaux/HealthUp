require 'test_helper'

class PostDeletionTest < ActionDispatch::IntegrationTest
  
  def setup
  	@cohort  = cohorts(:one)
  	@user 	 = users(:adam)
  	@post 	 = @cohort.posts.create(title: "Test", body: "Test body",
  																 author_id: @user.id)
  	log_in_as @user
  end

  test "must be logged in to delete post" do
  	delete logout_path
  	assert_not is_logged_in?
  	assert_no_difference "Post.count" do
  		delete post_path(@post)
  	end
  	assert_redirected_to login_path
  end

  test "must be admin to delete post" do
  	@user.toggle!(:admin)
  	assert_not @user.admin?
  	assert_no_difference "Post.count" do
  		delete post_path(@post)
  	end
  	assert_redirected_to root_path
  end

  test "successful post deletion" do
  	assert_difference "Post.count", -1 do
  		delete post_path(@post)
  	end
  	assert_redirected_to @cohort
  end
end
