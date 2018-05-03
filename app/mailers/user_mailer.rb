class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activate Your New Account"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Reset Your Password"
  end
end
