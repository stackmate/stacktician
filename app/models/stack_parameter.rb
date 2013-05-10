class StackParameter < ActiveRecord::Base
  attr_accessible :param_name, :param_value, :stack_id
  belongs_to :stack
end
