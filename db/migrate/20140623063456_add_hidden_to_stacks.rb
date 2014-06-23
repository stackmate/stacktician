class AddHiddenToStacks < ActiveRecord::Migration
  def change
    add_column :stacks, :hidden, :boolean
  end
end
