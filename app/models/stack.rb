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

  private

    def create_stack_id
      self.stack_id = SecureRandom.urlsafe_base64
    end
end
