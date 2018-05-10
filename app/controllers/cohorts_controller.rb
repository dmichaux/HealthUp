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
		@cohort = Cohort.find(params[:id])
		@unassigned = User.where(activated: true).where(cohort_id: nil)
	end

	def add_users
		cohort = Cohort.find(params[:id])
		ids = params[:assigned][:user_ids]
		ids.each do |id|
			User.find(id).update_attribute(:cohort_id, cohort.id)
		end
		flash[:notice] = "Clients added"
		redirect_to cohort_path cohort
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
end
