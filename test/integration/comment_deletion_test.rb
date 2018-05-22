require 'test_helper'

class CommentDeletionTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user 	 = users(:adam)
  	@user2	 = users(:beth)
  	post 		 = posts(:one)
  	@comment = post.comments.create(body: "test comment",
  																	author_id: @user2.id)
  	log_in_as @user
  end

  test "must be logged in to delete comment" do
  	delete logout_path
  	assert_no_difference "Comment.count" do
  		delete comment_path(@comment)
  	end
  	assert_redirected_to login_path
  end

  test "non-admin cannot delete another user's comment" do
  	@user.toggle!(:admin)
  	assert_not @user.admin?
  	assert_no_difference "Comment.count" do
  		delete comment_path(@comment)
  	end
  	assert_redirected_to root_path
  end

  test "non-admin can delete own comment" do
  	log_in_as @user2
  	assert_not @user2.admin?
  	assert_difference "Comment.count", -1 do
  		delete comment_path(@comment)
  	end
  	assert_response :redirect
  	assert_not flash.empty?
  end

  test "admin can delete any comment" do
  	assert @user.admin?
  	assert_difference "Comment.count", -1 do
  		delete comment_path(@comment)
  	end
  	assert_response :redirect
  	assert_not flash.empty?
  end
end
