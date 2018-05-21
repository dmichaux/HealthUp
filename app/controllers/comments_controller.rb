class CommentsController < ApplicationController

	before_action :require_login
	before_action :require_admin, only: :destroy

	def create
	end

	def destroy
	end
end
