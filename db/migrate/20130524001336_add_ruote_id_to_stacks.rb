class AddRuoteIdToStacks < ActiveRecord::Migration
  def change
    add_column :stacks, :ruote_wfid, :string
  end
end
