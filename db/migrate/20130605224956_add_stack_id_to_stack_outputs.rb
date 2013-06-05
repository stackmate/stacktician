class AddStackIdToStackOutputs < ActiveRecord::Migration
  def change
    add_column :stack_outputs, :stack_id, :integer
  end
end
