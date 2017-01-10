class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    sorted_posts = Post.all.order('cached_votes_score desc')
    @posts = sorted_posts.paginate(:page => params[:page], :per_page => 5)
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was updated."
    else
      render "edit"
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def upvote
    @post = Post.find(params[:id])
    if current_user.voted_up_on? @post
      @post.unliked_by current_user
    else
      @post.liked_by current_user
    end
    redirect_to :back
  end

  def downvote
    @post = Post.find(params[:id])
    if current_user.voted_down_on? @post
      @post.undisliked_by current_user
    else
      @post.disliked_by current_user
    end
    redirect_to :back
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :body)
  end

end
