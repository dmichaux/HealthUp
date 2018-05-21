require 'test_helper'

class CommentPostingTest < ActionDispatch::IntegrationTest
  
  def setup
  	@cohort = cohorts(:one)
  	@user 	= users(:adam)
  	@post 	= @cohort.posts.create(title: "Hi", body: "Hello",
  																 author_id: @user.id)
  	log_in_as @user
  end

  test "must be logged in to comment" do
  	delete logout_path
  	assert_not is_logged_in?
  	assert_no_difference "Comment.count" do
  		post comments_path, params: { comment: { body: 		 "Great post!",
  																						 post_id: 	@post.id,
  																						 author_id: @user.id } }
  	end
  	assert_redirected_to login_path
  end

  test "invalid body" do
  	assert_no_difference "Comment.count" do
  		post comments_path, params: { comment: { body: 		 "",
  																						 post_id: 	@post.id,
  																						 author_id: @user.id, } }
  	end
  	assert_template 'cohorts/show'
		assert_select "div.text-danger"
  end

  test "valid comment submission" do
  	assert_difference "Comment.count", 1 do
  		post comments_path, params: { comment: { body: 		 "Great post!",
  																						 post_id: 	@post.id,
  																						 author_id: @user.id } }
  	end
  	assert_redirected_to @cohort
  end
end
