class StackTemplate < ActiveRecord::Base
  attr_accessible :body, :category, :description, :public, :template_name, :template_url
  belongs_to :user

  validates :template_name, presence: true,  length: { maximum: 50 }, uniqueness: true
  validates :user_id, presence: true
  default_scope order: 'stack_templates.created_at DESC'
end
