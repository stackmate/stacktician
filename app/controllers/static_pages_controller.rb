class StaticPagesController < ApplicationController
  def home
      if signed_in?
        @stack = current_user.stacks.where(:hidden => false).build
        @stacks = current_user.stacks.where(:hidden => false).paginate(page: params[:page])
      end
  end

  def help
  end
end
