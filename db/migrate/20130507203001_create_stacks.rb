class CreateStacks < ActiveRecord::Migration
  def change
    create_table :stacks do |t|
      t.string :stack_id
      t.integer :user_id
      t.string :stack_name
      t.string :status
      t.string :reason
      t.string :description

      t.timestamps
    end
    add_index :stacks, [:user_id, :created_at]
    add_index :stacks, [:stack_name]
    add_index :stacks, [:status]
  end
end
