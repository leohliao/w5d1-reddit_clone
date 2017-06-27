class SubsController < ApplicationController


before_action :require_moderator, only: [:edit, :update]
before_action :require_logged_in, except: [:index, :show]

	def new 
		@sub = Sub.new
		render :new
	end

	def create
		@sub = current_user.subs.new(sub_params)

		if @sub.save 
			redirect_to sub_url(@sub)
		else 
			flash[:errors] = @sub.errors.full_messages
			render :new
		end 
	end

	def index
		@sub = Sub.all
		render :index
	end

	def show
		@sub = Sub.find(params[:id])
		render :show
	end

	def edit
		@sub = Sub.find(params[:id])
		render :edit
	end

	def update
		@sub = Sub.find(params[:id])

		if @sub.update_attributes(sub_params)
			redirect_to sub_url(@sub)
		else 
			flash[:errors] = @sub.errors.full_messages
			render :edit
		end 
	end

	def destroy
		@sub = Sub.find(params[:id])
		@sub.destroy
		redirect_to sub_url(@sub)
	end

	private 
	def sub_params
		params.require(:sub).permit(:name, :description)
	end

	def require_moderator
		return if current_user.subs.find_by(id: params[:id])
    	render json: "Forbidden", status: :forbidden
		
	end
end
