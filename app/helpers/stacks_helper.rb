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

  def resource_status_style(resource)
      # CREATE_IN_PROGRESS | CREATE_FAILED | CREATE_COMPLETE | DELETE_IN_PROGRESS | DELETE_FAILED | DELETE_COMPLETE 
      cls = 'info'
      case resource.status
      when /_IN_PROGRESS/
        cls = 'warning'
      when /_FAILED/
        cls = 'error'
      when /_COMPLETE/
        cls = 'success'
      end
      cls
  end

  def uri?(physical_id)
    uri = URI.parse(physical_id)
    %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
  end

end
