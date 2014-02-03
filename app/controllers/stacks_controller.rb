class StacksController < ApplicationController
  before_filter :signed_in_user, :except => [:wait_condition]

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
  #FIXME: unsure of response if handle is not found
  def wait_condition
    #format of handle spec is 
    # <wfid>/<wait handle name>
    # e.g., 20130529-0032-noyokuse-piriyasa/WaitHandle
    handle_parts = params[:handle_spec].split('/')
    wfid = handle_parts[0]
    handle = handle_parts[1]
    @stack = Stack.find_by_ruote_wfid(wfid)
    return if @stack == nil #TODO throw exception?
    @stack.wait_condition(handle)
    #cfn-signal does not expect anything in response
    render :nothing =>true
  end

end
