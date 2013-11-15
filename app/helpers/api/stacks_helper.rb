module API::StacksHelper
	def authenticate_user
    @api_user = User.find(1)
    true
  end
end
