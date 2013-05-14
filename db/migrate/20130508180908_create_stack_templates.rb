class CreateStackTemplates < ActiveRecord::Migration
  def change
    create_table :stack_templates do |t|
      t.string :template_url
      t.integer :user_id
      t.string :template_name
      t.string :description
      t.text :body, :limit => nil
      t.string :category
      t.boolean :public

      t.timestamps
    end
    add_index :stack_templates, [:template_name]
    add_index :stack_templates, [:public]
  end
end
