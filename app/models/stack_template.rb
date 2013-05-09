class StackTemplate < ActiveRecord::Base
  attr_accessible :body, :category, :description, :public, :template_name, :template_url, :user_id
  belongs_to :user
  has_many :stacks

  validates :template_name, presence: true,  length: { maximum: 50 }, uniqueness: true
  default_scope order: 'stack_templates.created_at DESC'
end
