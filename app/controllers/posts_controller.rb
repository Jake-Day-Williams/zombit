class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render 'new'
    end
  end


  private

  def find_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:title, :url, :body)
  end

end
