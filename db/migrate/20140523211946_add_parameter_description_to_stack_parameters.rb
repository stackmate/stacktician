class AddParameterDescriptionToStackParameters < ActiveRecord::Migration
  def change
    add_column :stack_parameters, :description, :string
  end
end
