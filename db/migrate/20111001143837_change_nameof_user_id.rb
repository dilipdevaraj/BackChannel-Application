class ChangeNameofUserId < ActiveRecord::Migration
  def up
    remove_column :posts, :userId,:integer
    add_column :posts, :user_id, :integer
  end

  def down
  end
end
