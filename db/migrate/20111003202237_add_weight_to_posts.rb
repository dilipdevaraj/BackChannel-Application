class AddWeightToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :weight, :integer
  end

  def down
  end

end
