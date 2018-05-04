require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  
  def setup
  	@user_1  = users(:adam)
  	@user_2  = users(:beth)
  	@message = @user_1.sent_messages.build(to_user_id: @user_2.id,
  																				 subject: 	 "Hello",
  																				 body: 			 "Have a great day!")
  end

  test "should be valid" do
  	assert @message.valid?
  end

  test "to_user_id should be present" do
  	@message.to_user_id = nil
  	assert_not @message.valid?
  end

  test "subject should be present" do
  	@message.subject = "   "
  	assert_not @message.valid?
  end

  test "subject should not exceed 50 characters" do
  	@message.subject = "x" * 51
  	assert_not @message.valid?
  end

  test "body should be present" do
  	@message.body = "    "
  	assert_not @message.valid?
  end

   test "body should not exceed 3000 characters" do
  	@message.body = "x" * 3001
  	assert_not @message.valid?
  end

  test "opened should default to false" do
    assert_not @message.opened?
  end

  test "should be ordered with most recent first" do
  	assert_equal messages(:most_recent), Message.first
  end
end
