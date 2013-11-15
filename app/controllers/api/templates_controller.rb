class API::TemplatesController < ApplicationController
  before_filter :authenticate_request

  def index
    @templates = StackTemplate.all
    render :json => {"error"=>"false","response" => {"templates" => @templates}}
  end

  def show
    begin
      @template = StackTemplate.find(params[:id])
      render :json => {"error"=>"false","response"=>{"template"=>@template}}
    rescue => e
      render :json => {"error"=>"true","message"=>e.message}
    end
  end

  def create
  end

  def destroy
  end
end