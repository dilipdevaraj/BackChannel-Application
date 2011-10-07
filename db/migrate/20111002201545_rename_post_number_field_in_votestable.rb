class RenamePostNumberFieldInVotestable < ActiveRecord::Migration
  def up
    rename_column :votes, :post_number, :post_id
  end

  def down
    rename_column :votes,  :post_id, :post_number
  end
end
