class AddStackTemplateIdToStack < ActiveRecord::Migration
  def change
    add_column :stacks, :stack_template_id, :integer
  end
end
