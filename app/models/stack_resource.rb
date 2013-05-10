class StackResource < ActiveRecord::Base
  attr_accessible :description, :logical_id, :physical_id, :stack_id, :status, :type
  belongs_to :stack
end
