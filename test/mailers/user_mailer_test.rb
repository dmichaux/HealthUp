require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
	
  test "account_activation" do
  	user = users(:adam)
  	user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Activate Your New Account", mail.subject
    assert_equal [user.email],								mail.to
    assert_equal ["noreply@healthup.com"],				mail.from
    assert_match user.name, 									mail.body.encoded
    assert_match user.activation_token, 			mail.body.encoded
    assert_match CGI.escape(user.email), 			mail.body.encoded
  end

  test "password_reset" do
    user = users(:adam)
    user.pass_reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Reset Your Password",  mail.subject
    assert_equal [user.email],           mail.to
    assert_equal ["noreply@healthup.com"],   mail.from
    assert_match user.name,              mail.body.encoded
    assert_match user.pass_reset_token,  mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end
end
