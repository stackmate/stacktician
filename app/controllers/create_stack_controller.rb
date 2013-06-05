class CreateStackController < ApplicationController
  include Wicked::Wizard
  steps :select_template, :enter_params, :launch

  def show
      case step
        when :select_template
          @stack = current_user.stacks.build()
           #logger.debug "stack: show :select_template #{@stack.attributes.inspect}"
        when :enter_params
          @stack = Stack.find_by_stack_name(session[:current_stack])
          logger.debug "stack: show :enter_params #{@stack.attributes.inspect}"
          stack_template = StackTemplate.find_by_id(@stack.stack_template_id)
          #logger.debug "stack_template: #{@stack_template.attributes.inspect}"
          @descr = stack_template.description
          #logger.debug "stack: show :launch #{@stack.attributes.inspect}"
        when :launch
          @stack = Stack.find_by_stack_name(session[:current_stack])
      end
      render_wizard 
  end

  def update
      case step
        when :select_template
          @stack = current_user.stacks.build()
          @stack.update_attributes(params[:stack])
          session[:current_stack] = @stack.stack_name
          @stack.params_from_template 
          logger.debug "params: #{@stack.stack_parameters.length}"
        when :enter_params
          @stack = Stack.find_by_stack_name(session[:current_stack])
          logger.debug "stack: update :enter_params #{@stack.attributes.inspect}"
          @stack.update_attributes(params[:stack])
        when :launch
          @stack = Stack.find_by_stack_name(session[:current_stack])
          @stack.status = 'CREATE_IN_PROGRESS'
          @stack.resources_from_template
          @stack.outputs_from_template
          logger.debug "stack: update :launch #{@stack.attributes.inspect}"
      end

      render_wizard @stack
  end

  def finish_wizard_path
     @stack = Stack.find_by_stack_name(session[:current_stack])
     @stack.launch
     root_url
  end

end
