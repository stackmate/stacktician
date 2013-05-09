module CreateStackHelper
    def current_stack_template (stack)
        StackTemplate.find_by_template_name(stack.stack_template)
    end
end
