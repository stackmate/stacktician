require 'spec_helper'

describe Stack do

  let(:user) { FactoryGirl.create(:user) }
  before { @stack = user.stacks.build(stack_name: "MyWiki1") }

  subject { @stack }

  it { should respond_to(:stack_name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }


  describe "when user_id is not present" do
    before { @stack.user_id = nil }
    it { should_not be_valid }
    describe "with blank name" do
      before { @stack.stack_name = " " }
      it { should_not be_valid }
    end

    describe "with name that is too long" do
      before { @stack.stack_name = "a" * 51 }
      it { should_not be_valid }
    end
  end
end
