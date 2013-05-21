module Stacktician
  module Participants

     def Participants.class_for(cf_resource)
       c = StackMate.class_for(cf_resource).gsub('StackMate', 'Stacktician')
     end

     def on_reply(work_item)
       logger.debug "In Stacktician::on_reply #{@opts.inspect}"
       stack = Stack.find(@opts['stack_id'])
       resource = stack.stack_resources.find_by_logical_id(@opts['participant'])
       resource.status = 'CREATE_COMPLETE'
       #logger.info "#{work_item[@opts['participant']].inspect}"
       resource.physical_id = work_item[@opts['participant']]['physical_id']
       resource.save
     end
  end

  class NoOpResource < StackMate::NoOpResource
    include Participants

    def initialize(opts)
      @opts = opts
    end

  end
end


