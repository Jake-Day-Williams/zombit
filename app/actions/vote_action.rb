class VoteAction

  def self.upvote(voter, item)
    if voter.voted_up_on? item
      item.unliked_by voter
      karma_change(item, -1)
    elsif voter.voted_down_on? item
      item.liked_by voter
      karma_change(item, 2)
    else
      item.liked_by voter
      karma_change(item, 1)
    end
  end

  def self.downvote(voter, item)
    if voter.voted_down_on? item
      item.undisliked_by voter
      karma_change(item, 1)
    elsif voter.voted_up_on? item
      item.disliked_by voter
      karma_change(item, -2)
    else
      item.disliked_by voter
      karma_change(item, -1)
    end
  end

  def self.karma_change(item, amount)
    item.user.increment!("#{item.model_name.param_key}_karma".to_sym, amount)
  end

end
