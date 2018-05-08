require 'test_helper'

class OutsideMessageTest < ActiveSupport::TestCase

	def setup
		@message = OutsideMessage.new(name: "Adam",
																	email: "a@example.com",
																	body: "Have a great day!",
																	to_admin_id: 1)
	end

	test "should be valid" do
		assert @message.valid?
	end

	test "email should be present" do
		@message.email = ""
		assert_not @message.valid?
	end

	test "email should be 5 - 254 characters long" do
		@message.email = "XXXX"
		assert_not @message.valid?
		@message.email = ("X" * 255)
		assert_not @message.valid?
	end

	test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @message.email = valid_address
      assert @message.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @message.email = invalid_address
      assert_not @message.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

	test "body should be present" do
		@message.body = ""
		assert_not @message.valid?
	end

	test "body should not exceed 2000 characters" do
  	@message.body = "x" * 2001
  	assert_not @message.valid?
  end

  test "opened should default to false" do
    assert_not @message.opened?
  end

	test "to_admin_id should be present" do
  	@message.to_admin_id = nil
  	assert_not @message.valid?
  end

  test "should be ordered with most recent first" do
  	assert_equal outside_messages(:most_recent), OutsideMessage.first
  end
end
