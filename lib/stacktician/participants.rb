require 'yaml'

module Stacktician
  module Participants

     def Participants.class_for(cf_resource)
       c = StackMate.class_for(cf_resource).gsub('StackMate', 'Stacktician')
     end

     def on_reply(work_item)
       logger.debug "In Stacktician::on_reply #{@opts.inspect}"
       ActiveRecord::Base.connection_pool.with_connection do
         stack = Stack.find(@opts['stack_id'])
         resource = stack.stack_resources.find_by_logical_id(@opts['participant'])
         resource.status = 'CREATE_COMPLETE'
         #logger.info "#{work_item[@opts['participant']].inspect}"
         resource.physical_id = work_item[@opts['participant']]['physical_id']
         resource.save
       end
     end
  end

  class NoOpResource < StackMate::NoOpResource
    include Participants

    def initialize(opts)
      @opts = opts
    end

  end

  class CloudStackInstance < StackMate::CloudStackInstance
    include Participants

    def initialize(opts)
      @opts = opts
      super(opts)
   end

   def load_local_mappings()
      begin
          @localized = YAML.load(ENV['CS_LOCAL'])
      rescue
          logger.warning "Warning: Failed to load localized mappings from environment var CS_LOCAL"
      end
   end

  end

  class CloudStackSecurityGroup < StackMate::CloudStackSecurityGroup
    include Participants

    def initialize(opts)
      @opts = opts
      super(opts)
    end

  end

  class WaitCondition < StackMate::WaitCondition
    include Participants

    def logger
       ::Rails.logger
    end

    def initialize(opts)
      @opts = opts
    end
  end

  class WaitConditionHandle < StackMate::WaitConditionHandle
    include Participants

    def logger
       ::Rails.logger
    end

    def initialize(opts)
      @opts = opts
    end

  end

  class Output < Ruote::Participant
    
    def initialize(opts)
        @opts = opts
    end

    def logger
       ::Rails.logger
    end

    def on_workitem
      logger.debug "In Stacktician::Output.on_workitem #{@opts.inspect}"
      ActiveRecord::Base.connection_pool.with_connection do
        stack = Stack.find(@opts['stack_id'])
        stack.status = 'CREATE_COMPLETE'
        stack.save
      end
      reply
    end

    def on_reply(work_item)
      logger.debug "In Stacktician::Output.on_reply #{@opts.inspect}"
     end

  end
end


