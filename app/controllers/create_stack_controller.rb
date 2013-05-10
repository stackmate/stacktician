class CreateStackController < ApplicationController
  include Wicked::Wizard
  steps :select_template, :enter_params, :launch

  def show
      case step
         when :select_template
           @stack = current_user.stacks.build()
           session[:current_stack] = @stack
           #logger.debug "stack: show :select_template #{@stack.attributes.inspect}"
        when :enter_params
          @stack = session[:current_stack]
          logger.debug "stack: show :enter_params #{@stack.attributes.inspect}"
          stack_template = StackTemplate.find_by_id(@stack.stack_template_id)
          #logger.debug "stack_template: #{@stack_template.attributes.inspect}"
          @descr = stack_template.description
          @params = params_from_template (stack_template.body)
        when :launch
          @stack = session[:current_stack]
          #logger.debug "stack: show :launch #{@stack.attributes.inspect}"
      end
      render_wizard 
  end

  def update
      case step
        when :enter_params
          @stack = session[:current_stack]
          logger.debug "stack: update :enter_params #{@stack.attributes.inspect}"
          @stack.update_attributes(params[:stack])
        when :select_template
          @stack = session[:current_stack]
          @stack.update_attributes(params[:stack])
          logger.debug "stack: update :select_template #{@stack.attributes.inspect}"
        when :launch
          @stack = session[:current_stack]
          @stack.update_attributes(params[:stack])
          logger.debug "stack: update :launch #{@stack.attributes.inspect}"
      end

      render_wizard @stack
  end

  def finish_wizard_path
     user_path(current_user)
  end

  private
    def params_from_template(template_body)
        j = JSON.parse(template_body)
        j['Parameters'].keys
    end

end
