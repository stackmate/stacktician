require 'spec_helper'

describe "Stack pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "stack creation" do
    before { visit root_path }

    describe "with invalid information" do

      #it "should not create a stack" do
        #expect { click_button "Create Stack" }.not_to change(Stack, :count)
      #end

      #describe "error messages" do
        #before { click_button "Create Stack" }
        #it { should have_content('error') } 
      #end
    end

  end
end
