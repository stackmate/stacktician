class CreateStackParameters < ActiveRecord::Migration
  def change
    create_table :stack_parameters do |t|
      t.string :param_name
      t.string :param_value
      t.integer :stack_id

      t.timestamps
    end
  end
end
