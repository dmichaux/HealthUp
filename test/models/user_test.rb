require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "Example User", email: "user@example.com")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "should not be admin" do
		assert_not @user.admin?
	end

	test "name should be present" do
		@user.name = "   "
		assert_not @user.valid?
	end

	test "name should be 3 - 25 characters long" do
		@user.name = "XX"
		assert_not @user.valid?
		@user.name = ("X" * 26)
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "   "
		assert_not @user.valid?
	end

	test "email should be 5 - 254 characters long" do
		@user.email = "XXXX"
		assert_not @user.valid?
		@user.email = ("X" * 255)
		assert_not @user.valid?
	end

	test "email should be saved downcase" do
		mixed_case_email = "Foo@BaR.cOm"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test "email should be unique" do
		user_2 = @user.dup
		user_2.email = @user.email.upcase
		@user.save
		assert_not user_2.valid?
	end

	test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "password_digest should be initialized by validations (on: :create)" do
  	assert_nil @user.password_digest
  	assert @user.valid?
  	assert_not_nil @user.password_digest
  end

  test "password_digest should be deleted after user creation" do
  	@user.save
  	assert_nil @user.password_digest
  end

  test "authenticated? should return false if remember digest is nil" do
  	assert_not @user.authenticated?(:remember, nil)
  end
end
