class StackOutput < ActiveRecord::Base
  attr_accessible :descr, :key, :value, :stack_id
  belongs_to :stack
end
