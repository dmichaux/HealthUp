class CohortsController < ApplicationController

	before_action :require_login
	before_action :require_admin, 							 except: :show
	before_action :require_participant_or_admin, only: 	 :show
	before_action :forbid_user_reassignment,		 only: 	 :add_users

	def index
		@cohorts = Cohort.all
	end

	def show
	end

	def new
		@cohort = Cohort.new
	end

	def create
		@cohort = Cohort.new(cohort_params)
		if @cohort.save
			flash[:notice] = "Cohort created"
			redirect_to @cohort
		else
			render :new
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	def select_users
		@cohort 		= Cohort.find(params[:id])
		@unassigned = User.where(activated: true).where(cohort_id: nil)
	end

	def add_users
		@users.each { |user| user.update_attribute(:cohort_id, @cohort.id) }
		flash[:notice] = "Client(s) added to cohort"
		redirect_to cohort_path @cohort
	end

	private

	def cohort_params
		params.require(:cohort).permit(:name, :description, :start_date, :end_date)
	end

	#Before Filters

	def require_participant_or_admin
		@cohort = Cohort.includes(:users).find(params[:id])
		participant = (current_user.cohort == @cohort) ? true : false
		unless participant || current_user.admin?
			redirect_to root_path
		end
	end

	def forbid_user_reassignment
		@cohort = Cohort.find(params[:id])
		@users  = params[:assigned][:user_ids].map { |id| User.find(id) }
		@users.each { |user| redirect_to root_path if user.cohort_id }
	end
end
