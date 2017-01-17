class AddCommentKarmaToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :comment_karma, :integer, :default => 0
  end
end
