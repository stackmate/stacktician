class CreateStackOutputs < ActiveRecord::Migration
  def change
    create_table :stack_outputs do |t|
      t.string :key
      t.string :value
      t.text :descr

      t.timestamps
    end
  end
end
