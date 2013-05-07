require 'spec_helper'

describe "Stack pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "stack creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a stack" do
        expect { click_button "Post" }.not_to change(Stack, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'stack_stack_name', with: "Lorem ipsum" }
      it "should create a stack" do
        expect { click_button "Post" }.to change(Stack, :count).by(1)
      end
    end
  end
end
