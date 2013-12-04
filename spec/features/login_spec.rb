require 'spec_helper'

describe "the login process", :type => :feature do
  it "asks the user to try again given an incorrect password" do
    visit '/login'

    fill_in 'username', :with => 'user@example.com'
    fill_in 'password', :with => 'password'

    click_button 'Log in'
    expect(page).to have_content 'Try again'
  end

  it "redirects to songs given a valid login and password" do
    visit '/login'

    fill_in 'username', :with => 'frank'
    fill_in 'password', :with => 'sinatra'

    click_button 'Log in'
    expect(page).to have_selector '#songs'
  end
end
