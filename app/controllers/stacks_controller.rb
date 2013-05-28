class StacksController < ApplicationController
  before_filter :signed_in_user

  def index
    @stacks = current_user.stacks
  end

  def show
    @stack = Stack.find(params[:id])
  end

  def create
    @stack = current_user.stacks.build(params[:stack])
    if @stack.save
      flash[:success] = "Stack created!"
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

  def destroy
  end

  #Respond to cfn-signal HTTP calls to unblock wait conditions
  #FIXME: move to stack model
  def wait_condition
    handle = params[:handle_spec].split('/')[1]
    #FIXME: get stack id from handle and wait condition name from stack_resource
    @condition = RUOTE.participant('WaitCondition') 
    #get the workitem by calling Ruote::StorageParticipant API
    wi = @condition.by_participant('WaitCondition')[0]
    #Tell the workflow to move forward
    @condition.proceed(wi)
    #cfn-signal does not expect anything in response
    render :nothing =>true
  end

end
