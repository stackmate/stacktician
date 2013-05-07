class StaticPagesController < ApplicationController
  def home
      @stack = current_user.stacks.build if signed_in?
  end

  def help
  end
end