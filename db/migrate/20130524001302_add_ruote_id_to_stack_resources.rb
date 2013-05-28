class AddRuoteIdToStackResources < ActiveRecord::Migration
  def change
    add_column :stack_resources, :ruote_feid, :string
  end
end
