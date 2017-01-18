module VotingController
  extend ActiveSupport::Concern

  included do
    before_filter :obtain_resources, only: [:upvote, :downvote]
  end

  def upvote
    if current_user.voted_down_on? @thing
      @thing.liked_by current_user
      karma_change(2)
    elsif current_user.voted_up_on? @thing
      @thing.unliked_by current_user
      karma_change(-1)
    else
      @thing.liked_by current_user
      karma_change(1)
    end
    redirect_back(fallback_location: root_path)
  end

  def downvote
    if current_user.voted_up_on? @thing
      @thing.disliked_by current_user
      karma_change(-2)
    elsif current_user.voted_down_on? @thing
      @thing.undisliked_by current_user
      karma_change(1)
    else
      @thing.disliked_by current_user
      karma_change(-1)
    end
    redirect_back(fallback_location: root_path)
  end

  def karma_change(amount)
    @thing.user.increment!("#{@thing.model_name.param_key}_karma".to_sym, amount)
  end


  private

  def obtain_resources
    # Retrieve name of the controller that triggered the action. Example: model = Post or Comment
    model = controller_name.singularize.camelize.constantize
    @thing = model.find(params[:id])  # Just like the find_post method in the posts controller. @post = Post.find(params[:id])
  end

end
