class Stack < ActiveRecord::Base
  attr_accessible :description, :reason, :stack_id, :stack_name, :status, :stack_template_id, :launched_at
  belongs_to :user
  belongs_to :stack_template

  before_save :create_stack_id

  validates :stack_name, presence: true,  length: { maximum: 50 }, uniqueness: true
  validates :user_id, presence: true
  default_scope order: 'stacks.created_at DESC'

  private

    def create_stack_id
      self.stack_id = SecureRandom.urlsafe_base64
    end
end
