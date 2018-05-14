class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Before filters

  def require_admin
  	redirect_to root_path unless current_user.admin?
  end

  def require_login
  	unless logged_in?
  		flash[:danger] = "Must be logged in to access content"
  		redirect_to login_path
  	end
  end
end
