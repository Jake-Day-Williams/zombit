class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_commentable
  before_action :set_comment, only: [:edit, :update, :destroy, :upvote, :downvote]

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new comment_params

    if @comment.commentable_type == "Post"
      @comment.root_post_id = @commentable.id
    else
      @comment.root_post_id = @commentable.root_post_id
    end

    if @comment.save
      redirect_to :back, notice: "Comment posted successfully"
    else
      redirect_to :back, notice: "Something went wrong."
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @comment[:body] = "[deleted]"
    @comment[:user_id] = nil
    if @comment.save
      redirect_to :back, notice: "Comment removed."
    end
  end

  def upvote
    VoteAction.upvote(current_user, @comment)
    redirect_back(fallback_location: root_path)
  end

  def downvote
    VoteAction.downvote(current_user, @comment)
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params[:comment][:user_id] = current_user.id
    params.require(:comment).permit(:body, :user_id, :root_post_id)
  end

  def find_commentable
    @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    @commentable = Post.find_by_id(params[:post_id]) if params[:post_id]
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

end
