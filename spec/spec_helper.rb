require 'bundler/setup'
require 'sinatra'
Sinatra::Application.environment = :test
Bundler.require :default, Sinatra::Application.environment
require 'rspec'
require 'capybara/rspec'
require File.dirname(__FILE__) + '/../main'

Sinatra::Application.root = Sinatra::Application.root + '/../'

Capybara.app = Sinatra::Application

def login!
  visit '/login'

  fill_in 'username', :with => 'frank'
  fill_in 'password', :with => 'sinatra'

  click_button 'Log in'
end
