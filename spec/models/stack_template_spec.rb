require 'spec_helper'

describe StackTemplate do

  let(:user) { FactoryGirl.create(:user) }
  before { @template = user.stack_templates.build(template_name: "MyWiki1") }

  subject { @template }

  it { should respond_to(:template_name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }


  describe "when user_id is not present" do
    before { @template.user_id = nil }
    it { should_not be_valid }
    describe "with blank name" do
      before { @template.template_name = " " }
      it { should_not be_valid }
    end

    describe "with name that is too long" do
      before { @template.template_name = "a" * 51 }
      it { should_not be_valid }
    end
  end
end
