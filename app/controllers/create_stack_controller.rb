class CreateStackController < ApplicationController
  include Wicked::Wizard
  steps :select_template, :enter_params, :launch

  def show
      @stack = current_user.stacks.build()
      session[:current_stack] = @stack
      render_wizard @stack
  end

  def update
      @stack = session[:current_stack]
      @stack.update_attributes(params[:stack])
      render_wizard @stack
  end

  def finish_wizard_path
     user_path(current_user)
  end

end
