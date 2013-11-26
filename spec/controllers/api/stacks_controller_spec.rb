require 'spec_helper'
require 'rack/test'

%w[ base64 cgi openssl uri digest/sha1 ].each { |f| require f }

include Rack::Test::Methods
def app
  Rails.application
end

describe API::StacksController do
  describe "GET stacks" do
    let(:good_url) { "api/stacks?apiKey=foo&signature=JwtGyDUNsCsEpVjKFYmmL15OyLU%3D" }
    let(:no_user_url) {"api/stacks?apiKey=blah&signature=ZZvNKSLbGgix8JMQMI3pRSoEmlg%3D"}
    let(:bad_signature) {"api/stacks?apiKey=foo&signature=JwtGyDUNsCsEpVjKFYmm"}
    before(:each) do
      @user = FactoryGirl.create(:user)
      @other_user = FactoryGirl.create(:user, api_key: "other_foo")
      #template = FactoryGirl.build(:stack_template)
      @stack = FactoryGirl.create(:stack, user: @user)
      @resource = FactoryGirl.create(:stack_resource, stack: @stack)
      @parameter = FactoryGirl.create(:stack_parameter, stack: @stack)
      @output = FactoryGirl.create(:stack_output, stack: @stack)
    end

    it "tests authentication when bad api key" do
      get no_user_url
      last_response.status.should == 404
    end

    it "tests authentication with bad signature" do
      get bad_signature
      last_response.status.should == 404
    end

    it "tests listing all stacks" do
      get good_url
      JSON.parse(last_response.body)["error"].should eq("false")
      JSON.parse(last_response.body)["response"]["stacks"].length.should == 1
    end

    it "checks correct response status for listing stacks" do
      get good_url
      last_response.status.should == 200
    end

    it "tests getting stack by id" do
      url = "api/stacks/"+@stack.stack_id+"?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => @stack.stack_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "false"
      JSON.parse(last_response.body)["response"]["stack"]["id"].should eq @stack.stack_id
    end

    it "tests error condition for stack by id" do
      fake_id = @stack.stack_id+"abcd"
      url = "api/stacks/"+fake_id+"?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => fake_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "true"
    end

    it "tests trying to list stack by another user" do
      url = "api/stacks/"+@stack.stack_id+"?apiKey=other_foo"
      pp = {
        "apiKey" => "other_foo",
        "id" => @stack.stack_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "true"
    end

    it "tests getting stack status" do
      url = "api/stacks/"+@stack.stack_id+"/status?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => @stack.stack_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "false"
      JSON.parse(last_response.body)["response"]["stack_id"].should eq @stack.stack_id
      JSON.parse(last_response.body)["response"]["status"].should eq @stack.status
    end

    it "tests error condition for getting stack status" do
      fake_id = @stack.stack_id+"abcd"
      url = "api/stacks/"+fake_id+"/status?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => fake_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "true"
    end

    it "tests getting stack parameters" do
      url = "api/stacks/"+@stack.stack_id+"/parameters?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => @stack.stack_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "false"
      JSON.parse(last_response.body)["response"]["stack_id"].should eq @stack.stack_id
      JSON.parse(last_response.body)["response"]["parameters"][0]["name"].should eq @parameter.param_name
      JSON.parse(last_response.body)["response"]["parameters"][0]["value"].should eq @parameter.param_value
    end

    it "tests error condition for getting stack parameters" do
      fake_id = @stack.stack_id+"abcd"
      url = "api/stacks/"+fake_id+"/parameters?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => fake_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "true"
    end

    it "tests getting stack resources" do
      url = "api/stacks/"+@stack.stack_id+"/resources?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => @stack.stack_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "false"
      JSON.parse(last_response.body)["response"]["stack_id"].should eq @stack.stack_id
      JSON.parse(last_response.body)["response"]["resources"][0]["name"].should eq @resource.logical_id
      #JSON.parse(last_response.body)["response"]["resources"][0]["timestamp"].should eq @resource.updated_at
      JSON.parse(last_response.body)["response"]["resources"][0]["physical_id"].should eq @resource.physical_id
    end

    it "tests error condition for getting stack resources" do
      fake_id = @stack.stack_id+"abcd"
      url = "api/stacks/"+fake_id+"/resources?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => fake_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "true"
    end

    it "tests getting stack outputs" do
      url = "api/stacks/"+@stack.stack_id+"/outputs?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => @stack.stack_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "false"
      JSON.parse(last_response.body)["response"]["outputs"][0]["name"].should eq @output.key
      JSON.parse(last_response.body)["response"]["outputs"][0]["value"].should eq @output.value
    end

    it "tests error condition for getting stack outputs" do
      fake_id = @stack.stack_id+"abcd"
      url = "api/stacks/"+fake_id+"/outputs?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => fake_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "true"
    end

    it "tests getting stack events" do
      url = "api/stacks/"+@stack.stack_id+"/events?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => @stack.stack_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "false"
      JSON.parse(last_response.body)["response"]["stack_id"].should eq @stack.stack_id
      JSON.parse(last_response.body)["response"]["events"][0]["name"].should eq @resource.logical_id
      #JSON.parse(last_response.body)["response"]["events"][0]["timestamp"].should eq @resource.updated_at
      JSON.parse(last_response.body)["response"]["events"][0]["physical_id"].should eq @resource.physical_id
      JSON.parse(last_response.body)["response"]["events"][0]["status"].should eq @resource.status
    end

    it "tests error condition for getting stack events" do
      fake_id = @stack.stack_id+"abcd"
      url = "api/stacks/"+fake_id+"/events?apiKey=foo"
      pp = {
        "apiKey" => "foo",
        "id" => fake_id,
      }
      data = pp.map{ |k,v| "#{k.to_s}=#{CGI.escape(v.to_s).gsub(/\+|\ /, "%20")}" }.sort.join('&')
      signature = OpenSSL::HMAC.digest 'sha1', "bar", data.downcase
      signature = Base64.encode64(signature).chomp
      signature = CGI.escape(signature)
      url = url + "&" + "signature="+signature
      get url
      last_response.status.should == 200
      JSON.parse(last_response.body)["error"].should eq "true"
    end

    it "tests getting particular status resource" do
    end

    it "tests error condition for getting particular stack resource" do

    end
  end
end