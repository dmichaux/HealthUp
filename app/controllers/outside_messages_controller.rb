class OutsideMessagesController < ApplicationController

	def new
		@outside_message = OutsideMessage.new
	end

	def create
		to_admin_id = { to_admin_id: User.where(admin: true).first.id }
		@outside_message = OutsideMessage.new(outside_message_params
																				 .merge(to_admin_id))
		if @outside_message.save
			flash[:success] = "Your message was sent"
			redirect_to root_path
		else
			render :new
		end
	end

	private

	def outside_message_params
		params.require(:outside_message).permit(:name, :email, :body)
	end
end
