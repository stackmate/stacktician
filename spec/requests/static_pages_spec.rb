require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Stack*tician" }

  describe "Home page" do

    it "should have the h1 'Stack*tician'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Stack*tician')
    end

  end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

  end

  describe "About page" do

    it "should have the h1 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About')
    end

  end
end
