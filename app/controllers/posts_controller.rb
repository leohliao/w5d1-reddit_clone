class PostsController < ApplicationController

	before_action :require_logged_in

	def new
		@post = Post.new 
		render :new 
	end

	def edit 
		@post = Post.find(params[:id])
		render :edit
	end

	def update
		@post = current_user.posts.find(params[:id])

		if @post.update(post_params)
			redirect_to post_url(@post)
		else 
			flash[:errors] = @post.errors.full_messages
			render :edit
		end 
	end

	private 
	def post_params
		params.require(:post).permit(:title, :url, :content, :user_id)
	end

	def require_author 
		return if current_user.posts.find(params[:id])
		render json: "Forbbiden", status: :forbidden
		
	end
end
