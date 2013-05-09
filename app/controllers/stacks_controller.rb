class StacksController < ApplicationController
  before_filter :signed_in_user

  def index
    @stacks = current_user.stacks
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

end
