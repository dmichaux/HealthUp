require 'test_helper'

class UserEditingTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:adam)
  	log_in_as @user
  	@new_name  = "New Name"
  	@new_email = "new@example.com"
  	@new_pass  = "newpass1"
  end

  test "cannot edit another user" do
  	@user2 = users(:beth)
  	get edit_user_path(@user2)
  	assert_redirected_to root_path
  	patch user_path(@user2), params: { user: { name: @new_name, email: @new_email,
  																						 password: 							 @new_pass,
  																						 password_confirmation:  @new_pass } }
  	assert_redirected_to root_path
  	assert_equal @user2.password_digest, @user2.reload.password_digest
  	assert_not_equal @new_name, @user2.name
  end

  test "valid name only" do
  	patch user_path(@user), params: { user: { name: @new_name } }
  	assert_equal @user.password_digest, @user.reload.password_digest
  	assert_equal @new_name, @user.name
  	assert_redirected_to @user
  end

  test "invalid name" do
  	patch user_path(@user), params: { user: { name: "" } }
  	assert_equal @user.password_digest, @user.reload.password_digest
  	assert_not_equal @new_name, @user.name
  	assert_template "users/edit"
		assert_select "div.text-danger"
  end

  test "valid email only" do
  	patch user_path(@user), params: { user: { email: @new_email } }
  	assert_equal @user.password_digest, @user.reload.password_digest
  	assert_equal @new_email, @user.email
  	assert_redirected_to @user
  end

  test "invalid email" do
  	patch user_path(@user), params: { user: { email: "" } }
  	assert_equal @user.password_digest, @user.reload.password_digest
  	assert_not_equal @new_email, @user.email
  	assert_template "users/edit"
		assert_select "div.text-danger"
  end

  test "valid password only" do
  	patch user_path(@user), params: { user: { password: 						 @new_pass,
  																						password_confirmation: @new_pass } }
  	assert_not_equal @user.password_digest, @user.reload.password_digest
  	assert @user.authenticate(@new_pass)
  	assert_redirected_to @user
  end

  test "valid name and email only" do
  	patch user_path(@user), params: { user: { name: @new_name, email: @new_email } }
  	assert_equal @user.password_digest, @user.reload.password_digest
  	assert_equal @new_name, @user.name
  	assert_equal @new_email, @user.email
  	assert_redirected_to @user
  end

  test "mismatched (invalid) password only" do
  	patch user_path(@user), params: { user: { password: 						 @new_pass,
  																						password_confirmation: "differentpass" } }
  	assert_equal @user.password_digest, @user.reload.password_digest
  	assert_not @user.authenticate(@new_pass)
  	assert_not @user.authenticate("differentpass")
  	assert_template "users/edit"
		assert_select "div.text-danger"
  end

  test "name, email, and mismatched (invalid) password" do
  	patch user_path(@user), params: { user: { name: @new_name, email: @new_email,
  																						password: 						  @new_pass,
  																						password_confirmation:  "differentpass" } }
  	assert_equal @user.password_digest, @user.reload.password_digest
  	assert_not_equal @new_name, @user.name
  	assert_not_equal @new_email, @user.email
  	assert_not @user.authenticate(@new_pass)
  	assert_not @user.authenticate("differentpass")
  	assert_template "users/edit"
		assert_select "div.text-danger"
  end

  test "successful edit with all valid fields" do
  	patch user_path(@user), params: { user: { name: @new_name, email: @new_email,
  																						password: 						  @new_pass,
  																						password_confirmation:  @new_pass } }
  	assert_not_equal @user.password_digest, @user.reload.password_digest
  	assert_equal @new_name, @user.name
  	assert_equal @new_email, @user.email
  	assert @user.authenticate(@new_pass)
  	assert_redirected_to @user
  end
end
