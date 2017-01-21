class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  def index
    sorted_posts = Post.all.order(cached_votes_score: :desc)
    @per_page = 20
    @posts = sorted_posts.page(params[:page]).per(@per_page)
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
    redirect_back(fallback_location: root_path)
  end

  def upvote
    VoteAction.upvote(current_user, @post)
    redirect_back(fallback_location: root_path)
  end

  def downvote
    VoteAction.downvote(current_user, @post)
    redirect_back(fallback_location: root_path)
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :body)
  end

end
