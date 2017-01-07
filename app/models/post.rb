class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable
  acts_as_votable
end
