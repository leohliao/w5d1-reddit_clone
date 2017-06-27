class SessionsController < ApplicationController
	before_action :require_logged_out, only: [:new, :create]
  	before_action :require_logged_in, only: [:destroy]

	private
	def new 
		render :new
	end

	def create 
		@user = User.find_by_credentials(params[:user][:name], 
										 params[:user][:password])

		if @user 
			log_in(@user)
			redirect_to subs_url
		else 
			flash[:errors] = ["Invalid name or password."]
			render :new
		end 
	end

	def destroy
		log_out! 
		redirect_to new_session_url
	end
end
