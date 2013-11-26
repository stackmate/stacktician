class AddTimeoutToStack < ActiveRecord::Migration
  def change
    add_column :stacks, :timeout, :integer, :default => 600
  end
end
