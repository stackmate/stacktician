require 'uri'
class API::TemplatesController < ApplicationController
  #before_filter :authenticate_request
  #TODO authentication with template APIs
  def index
    @templates = StackTemplate.all
    templates = []
    @templates.each do |t|
    	template = {}
    	template['name'] = t.template_name
    	template['body'] = t.body
    	template['description'] = t.description
    	template['template_id'] = t.id
    	templates.push(template)
    end
    render :json => {"error"=>"false","response" => {"templates" => templates}}
  end

  def show
    begin
      @template = StackTemplate.find(params[:id])
      template = {}
    	template['name'] = @template.template_name
    	template['body'] = @template.body
    	template['description'] = @template.description
    	template['template_id'] = @template.id
      render :json => {"error"=>"false","response"=>{"template"=>template}}
    rescue => e
      render :json => {"error"=>"true","message"=>e.message}
    end
  end

  def create
    begin
      body = params[:body]
      template_body = URI.decode(body)
      descr = params[:description]
      template_name = params[:name]
      is_public = true
      category = 'General'
      template_url = "API"
      template = StackTemplate.create!(user_id:1, template_url: template_url, template_name: template_name, description: descr, body: template_body, category: category, public: is_public)
      render :json => {"error" => "false","response"=>{"template"=>{"id"=>template.id}}}
    rescue => e
      render :json => {"error" => "true","message" => e.message}
    end
  end

  def destroy
  end
end