class MessagesController < ApplicationController

	before_action :require_login

	def create
		@message = current_user.sent_messages.build(message_params)
		@user = User.find(params[:message][:to_user_id])
		if @message.save
			flash[:success] = "Message was sent"
			redirect_to @user
		else
			render "users/show"
		end
	end

	def open
		Message.find(params[:id]).open_message
		respond_to do |format|
			format.html { redirect_to current_user }
			format.js
		end
	end

	private

	def message_params
		params.require(:message).permit(:body, :to_user_id)
	end
end
