class Stack < ActiveRecord::Base
  attr_accessible :description, :reason, :stack_id, :stack_name, :status, :stack_template_id, :launched_at, :stack_parameters_attributes
  belongs_to :user
  belongs_to :stack_template
  has_many :stack_resources, :dependent => :destroy
  has_many :stack_parameters, :dependent => :destroy
  accepts_nested_attributes_for :stack_parameters, :reject_if => lambda { |p| p[:param_value].blank? }
  #accepts_nested_attributes_for :stack_parameters

  before_save :create_stack_id

  validates :stack_name, presence: true,  length: { maximum: 50 }, uniqueness: true
  validates :user_id, presence: true
  default_scope order: 'stacks.created_at DESC'

  def params_from_template
    j = JSON.parse(self.stack_template.body)
    j['Parameters'].each do |p| 
      param = self.stack_parameters.build()
      param.param_name = p[0]
      param.param_value = p[1]['Default']
    end
  end

  def resources_from_template
    j = JSON.parse(self.stack_template.body)
    j['Resources'].each {  |key, val|
      resource = self.stack_resources.build()
      resource.logical_id = key
      resource.typ = val['Type']
      resource.status = 'CREATE_IN_PROGRESS'
    }
  end

  private

    def create_stack_id
      self.stack_id = SecureRandom.urlsafe_base64
    end
end
