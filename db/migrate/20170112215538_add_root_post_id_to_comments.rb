class AddRootPostIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :root_post_id, :integer
  end
end
