require 'test_helper'

class PostEditingTest < ActionDispatch::IntegrationTest
  
  def setup
  	@cohort = cohorts(:one)
  	@user 	= users(:adam)
  	@post 	= @cohort.posts.create(title: "Test", body: "Test body",
  																author_id: @user.id)
  	log_in_as @user
  end

  test "must be logged in to edit post" do
  	delete logout_path
  	assert_not is_logged_in?
  	get edit_post_path(@post)
  	assert_redirected_to login_path
  	patch post_path(@post), params: { post: { title: "New Title",
  																						body:  "New test body" } }
  	assert_redirected_to login_path
  end

  test "must be admin to edit post" do
  	@user.toggle!(:admin)
  	assert_not @user.admin?
  	get edit_post_path(@post)
  	assert_redirected_to root_path
  	patch post_path(@post), params: { post: { title: "New Title",
  																						body:  "New test body", } }
  	assert_redirected_to root_path
  end

  test "cannot alter IDs" do
  	new_id = 7
  	assert_not_equal @post.author_id, new_id
  	assert_not_equal @post.cohort_id, new_id
  	patch post_path(@post), params: { post: { title: 		 "New Title",
  																						body: 		 "New test body",
  																						author_id: new_id,
  																						cohort_id: new_id } }
  	@post.reload
  	assert_not_equal @post.author_id, new_id
  	assert_not_equal @post.cohort_id, new_id
  end

  test "successful post edit" do
  	title = "New Post Title"
  	body	= "New body for post."
  	patch post_path(@post), params: { post: { title: title,
  																						body:  body } }
  	@post.reload
  	assert_equal title, @post.title
  	assert_equal body, @post.body
  	assert_redirected_to @cohort
  end
end
