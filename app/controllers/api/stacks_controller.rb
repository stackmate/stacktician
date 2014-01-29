class API::StacksController < ApplicationController
  before_filter :authenticate_request, :except => [:resource_metadata, :resource_metadata_cfn]

  def index
    @stacks = @api_user.stacks
    stacks_list = []
    @stacks.each do |s|
      stack = {}
      stack['name'] = s.stack_name
      stack['status'] = s.status
      stack['id'] = s.stack_id
      stack['description'] = s.description
      stack['create_timestamp'] = s.created_at
      stack['update_timestamp'] = s.updated_at
      stack['creation_timeout'] = s.timeout
      stack['parameters'] = params_for_stack(s)
      stack['resources'] = resources_for_stack(s)
      stack['outputs'] = outputs_for_stack(s)
      stacks_list.push(stack)
    end
    render :json => {"error" => "false","response"=>{"stacks"=>stacks_list}}
  end

  def show
    begin
      @stack = @api_user.stacks.find_by_stack_id!(params[:id])
      s = {}
      s['name'] = @stack.stack_name
      s['status'] = @stack.status
      s['id'] = @stack.stack_id
      s['description'] = @stack.description
      s['create_timestamp'] = @stack.created_at
      s['update_timestamp'] = @stack.updated_at
      s['creation_timeout'] = @stack.timeout
      s['parameters'] = params_for_stack(@stack)
      s['resources'] = resources_for_stack(@stack)
      s['outputs'] = outputs_for_stack(@stack)
      render :json => {"error" => "false","response"=>{"stack" => s}}
    rescue ActiveRecord::RecordNotFound
      render :json => {"error" => "true","message"=>"Stack " + params[:id] +" not found"}
    end
  end

  def new
    begin
      template_id = params[:template_id]
      raise "Invalid template id" if StackTemplate.find(template_id).nil?
      #parameters = params[:parameters]
      @stack = @api_user.stacks.build()
      ensure_parameters(template_id)
      @stack.stack_name = params[:stack_name]
      raise "Stack Name needed and should be unique" if (params[:stack_name].nil? || !Stack.find_by_stack_name(params[:stack_name]).nil?)
      @stack.status = "CREATE_IN_PROGRESS"
      @stack.save
      @stack.stack_template_id = template_id
      @stack.params_from_template
      @stack.resources_from_template
      @stack.outputs_from_template

      @stack.stack_parameters.each do |p|
        p.param_value = params[p.param_name] if params.has_key?(p.param_name)
        p.save
      end
      @stack.save
      @stack.launch
      render :json => {"error" => "false","response"=>{"id"=>@stack.stack_id}}
    rescue => e
      render :json => {"error" => "true","message" => e.message}
    end
  end

  def destroy
  end

  def status
    begin
      @stack = @api_user.stacks.find_by_stack_id!(params[:id])
      render :json => {"error" => "false","response"=>{"stack_id" => params[:id],"status" => @stack.status}}
    rescue ActiveRecord::RecordNotFound
      render :json => {"error" => "true","message"=>"Stack " + params[:id] +" not found"}
    end
  end

  def resource
    @stack = @api_user.stacks.find_by_stack_id!(params[:id])
    r = @stack.stack_resources.find_by_logical_id!(params[:name])
    resource = {}
    resource['name'] = r.logical_id
    #event['description'] = r.description
    resource['physical_id'] = r.physical_id
    resource['status'] = r.status
    resource['timestamp'] = r.updated_at
    resource['type'] = r.typ
    render :json => {"error" => "false","response"=>{"stack_id" => params[:id],"resource_name" => params[:name],"resource" => resource}}
  end

  def resource_metadata
    @stack = Stack.find_by_stack_id!(params[:id])
    r = @stack.stack_resources.find_by_logical_id!(params[:name])
    resource = {}
    resource['name'] = r.logical_id
    resource['status'] = r.status
    resource['metadata'] = r.metadata
    render :json => {"error" => "false","response"=>{"stack_id" => params[:id],"resource_name" => params[:name],"resource" => resource}}
  end

  def resource_metadata_cfn
    @stack = Stack.find_by_stack_name!(params[:StackName])
    r = @stack.stack_resources.find_by_logical_id!(params[:LogicalResourceId])
    data = {}
    data['Description'] = r.description
    data['ResourceType'] = r.typ
    data['LogicalResourceId'] = r.logical_id
    data['Metadata'] = r.metadata.to_json
    data['PhysicalResourceId'] = r.physical_id
    data['ResourceStatus'] = r.status
    data['ResourceStatusReason'] = ''
    data['StackId'] = @stack.stack_id
    data['StackName'] = params[:StackName]
    data['LastUpdatedTimestamp'] = 1388746890.0
    respmetadata = {}
    respmetadata['RequestId'] = "be8e5b39-40b7-11e3-90b2-d9d62a5d5348"
    data['ResponseMetadata'] = respmetadata
    detail = {}
    detail['StackResourceDetail'] = data
    result = {}
    result['DescribeStackResourceResult'] = detail
    #response = {}
    #response['DescribeStackResourceResponse'] = result
    render :json => {"DescribeStackResourceResponse" => result}
  end

  def resources
    begin
      @stack = @api_user.stacks.find_by_stack_id!(params[:id])
      resources = resources_for_stack(@stack)
      render :json => {"error" => "false","response"=>{"stack_id" => params[:id],"resources" => resources}}
    rescue ActiveRecord::RecordNotFound
      render :json => {"error" => "true","message"=>"Stack " + params[:id] +" not found"}
    end
  end

  def parameters
    begin
      @stack = @api_user.stacks.find_by_stack_id!(params[:id])
      parameters = params_for_stack(@stack)
      render :json => {"error" => "false","response"=>{"stack_id" => params[:id],"parameters" => parameters}}
    rescue ActiveRecord::RecordNotFound
      render :json => {"error" => "true","message"=>"Stack " + params[:id] +" not found"}
    end
  end

  def events
    begin
      @stack = @api_user.stacks.find_by_stack_id!(params[:id])
      events = events_for_stack(@stack)
      render :json => {"error" => "false","response"=>{"stack_id" => params[:id],"events" => events}}
    rescue ActiveRecord::RecordNotFound
      render :json => {"error" => "true","message"=>"Stack " + params[:id] +" not found"}
    end
  end

  def outputs
    begin
      @stack = @api_user.stacks.find_by_stack_id!(params[:id])
      outputs = outputs_for_stack(@stack)
      render :json => {"error" => "false","response"=>{"stack_id" => params[:id],"status"=>@stack.status,"outputs" => outputs}}
    rescue ActiveRecord::RecordNotFound
      render :json => {"error" => "true","message"=>"Stack " + params[:id] +" not found"}
    end
  end

  def ensure_parameters(template_id)
    template = StackTemplate.find(template_id)
    parameters = JSON.parse(template.body)['Parameters']
    missing = []
    parameters.each do |p|
      missing.push(p[0]) if (p[1]['Default'].nil? && !params.has_key?(p[0]))
    end
    raise "Missing parameters for " + missing.join(",") if !missing.empty?
  end

  def params_for_stack(stack)
    parameters = []
    stack.stack_parameters.each do |p|
      stack_param = {}
      stack_param['name'] = p.param_name
      stack_param['value'] = p.param_value
      parameters.push(stack_param)
    end
    parameters
  end

  def resources_for_stack(stack)
    resources = []
    stack.stack_resources.each do |r|
      resource = {}
      resource['name'] = r.logical_id
      #event['description'] = r.description
      resource['physical_id'] = r.physical_id
      resource['status'] = r.status
      resource['timestamp'] = r.updated_at
      resource['type'] = r.typ
      resources.push(resource)
    end
    resources
  end

  def outputs_for_stack(stack)
    outputs = []
    stack.stack_outputs.each do |o|
      output = {}
      output['name'] = o.key
      output['value'] = o.value
      output['description'] = o.descr
      outputs.push(output)
    end
    outputs
  end

  def events_for_stack(stack)
    events = []
    stack.stack_resources.each do |r|
      event = {}
      event['name'] = r.logical_id
      #event['description'] = r.description
      event['physical_id'] = r.physical_id
      event['status'] = r.status
      event['timestamp'] = r.updated_at
      event['type'] = r.typ
      events.push(event)
    end
    events
  end
end