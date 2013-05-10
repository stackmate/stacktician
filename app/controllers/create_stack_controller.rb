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
          stack_template = StackTemplate.find_by_id(@stack.stack_template_id)
          @params = params_from_template @stack, stack_template.body
          logger.debug "params: #{@stack.stack_parameters.length}"
        when :enter_params
          @stack = Stack.find_by_stack_name(session[:current_stack])
          logger.debug "stack: update :enter_params #{@stack.attributes.inspect}"
          @stack.update_attributes(params[:stack])
        when :launch
          @stack = Stack.find_by_stack_name(session[:current_stack])
          @stack.status = 'CREATE_IN_PROGRESS'
          stack_template = StackTemplate.find_by_id(@stack.stack_template_id)
          @resources = resources_from_template @stack, stack_template.body
          logger.debug "stack: update :launch #{@stack.attributes.inspect}"
      end

      render_wizard @stack
  end

  def finish_wizard_path
     root_url
  end

  private
    def params_from_template(stack, template_body)
        j = JSON.parse(template_body)
        params = []
        j['Parameters'].each do |p| 
          param = stack.stack_parameters.build()
          param.param_name = p[0]
          param.param_value = p[1]['Default']
          params << param
        end
        params
    end

    def resources_from_template(stack, template_body)
        j = JSON.parse(template_body)
        resources = []
        j['Resources'].each {  |key, val|
          resource = stack.stack_resources.build()
          resource.logical_id = key
          resource.type = val['Type']
          resource.status = 'CREATE_IN_PROGRESS'
          resources << resource
        }
        resources
    end

end
