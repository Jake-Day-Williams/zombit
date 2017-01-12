class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable
  acts_as_votable

  def all_comments
    Comment.where(root_post_id: id)
  end
  
end
