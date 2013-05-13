module StacksHelper
  def stack_status_style(stack)
      # CREATE_IN_PROGRESS | CREATE_FAILED | CREATE_COMPLETE | DELETE_IN_PROGRESS | DELETE_FAILED | DELETE_COMPLETE 
      cls = 'info'
      case stack.status
      when /_IN_PROGRESS/
        cls = 'warning'
      when /_FAILED/
        cls = 'error'
      when /_COMPLETE/
        cls = 'success'
      end
      cls
  end

end
