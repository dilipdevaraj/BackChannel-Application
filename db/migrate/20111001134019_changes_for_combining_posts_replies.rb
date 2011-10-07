class ChangesForCombiningPostsReplies < ActiveRecord::Migration
  def up
    remove_column :posts, :userName, :string
    add_column :posts, :postId, :integer
    add_column :posts, :userId, :integer
  end

  def down

    add_column :posts, :userName, :string
    remove_column :posts, :postId, :integer
    remove_column :posts, :userId, :integer
  end
end
