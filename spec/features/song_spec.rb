require 'spec_helper'

describe "songs", :type => :feature do
  before(:each) do
    login!
    visit '/songs'

    click_link 'Create a new song'
    fill_in 'song[title]', :with => 'Jingle Bells'
    fill_in 'song[length]', :with => '1'
    fill_in 'song[released_on]', :with => '12/25/2013'
    fill_in 'song[lyrics]', :with => 'Jingle Bells, Jingle Bells'

    click_button 'Save Song'
  end

  it "shows newly created songs" do
    expect(page).to have_content 'Jingle Bells'
  end

  it 'can be edited' do
    click_link 'Edit this song'

    fill_in 'song[title]', :with => 'test'
    click_button 'Save Song'

    expect(page).to have_content 'test'

  end
end

