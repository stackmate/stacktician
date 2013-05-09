class AddLaunchedAtToStack < ActiveRecord::Migration
  def change
    add_column :stacks, :launched_at, :datetime
  end
end
