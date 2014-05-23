class StackParameter < ActiveRecord::Base
  attr_accessible :param_name, :param_value, :description, :stack_id
  belongs_to :stack
end
