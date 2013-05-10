class CreateStackResources < ActiveRecord::Migration
  def change
    create_table :stack_resources do |t|
      t.string :logical_id
      t.string :physical_id
      t.integer :stack_id
      t.string :status
      t.string :description
      t.string :type

      t.timestamps
    end
  end
end
