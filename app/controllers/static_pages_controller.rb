class StaticPagesController < ApplicationController
  def home
      if signed_in?
        @stack = current_user.stacks.build
        @stacks = current_user.stacks.paginate(page: params[:page])
      end
  end

  def help
  end
end
