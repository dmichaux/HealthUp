class CohortsController < ApplicationController

	before_action :require_login
	before_action :require_admin, 							 except: :show
	before_action :require_participant_or_admin, only: 	 :show

	def index
		@cohorts = Cohort.all
	end

	def show
	end

	def new
		@cohort = Cohort.new
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

	def require_participant_or_admin
		@cohort = Cohort.find(params[:id])
		participant = (current_user.cohort == @cohort) ? true : false
		unless participant || current_user.admin?
			redirect_to root_path
		end
	end
end
