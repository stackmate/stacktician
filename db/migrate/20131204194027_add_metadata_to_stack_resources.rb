class AddMetadataToStackResources < ActiveRecord::Migration
  def change
    add_column :stack_resources, :metadata, :text 
  end
end
