require 'sinatra/base'
# require 'sinatra/reloader' if development?
require 'sinatra/flash'
require 'slim'
require 'sass'
require 'pony'
require 'coffee-script'
require 'v8'
require './song'
require './sinatra/auth'
require './applicationcontroller'
require './asset-handler'

class Website < ApplicationController
  use AssetHandler

  configure do
    enable :sessions
  end

  configure :development do
    set :email_options, {
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => '',
        :password             => '',
        :authentication       => :plain,
        :domain               => "localhost.localdomain"
      }
    }
  end

  configure :production do
    set :email_options, {
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.sendgrid.net',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => ENV['SENDGRID_USERNAME'],
        :password             => ENV['SENDGRID_PASSWORD'],
        :authentication       => :plain,
        :domain               => 'songs-by-sinatra-dansturner.heroku.com'
      }
    }
  end

  before do
    set_title
  end

  def css(*stylesheets)
    stylesheets.map do |sheet|
      "<link href=\"/#{sheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def js(*scripts)
    scripts.map do |script|
      "<script src=\"/javascripts/#{script}.js\"></script>"
    end.join
  end

  def current?(path = '/')
    "current" if (request.path == path || request.path == path + "/")
  end

  def send_message
    Pony.mail(
      :from => "#{params[:name]} <#{params[:email]}>",
      :to => "turner@nowwithmoredan.com",
      :subject => "Message from #{params[:name]}",
      :body => params[:message],
      )
  end

  def set_title
    @title ||= ""
  end

  get '/' do
    @title = "Home"
    slim :home
  end

  get '/about' do
    slim :about
  end

  get '/contact' do
    slim :contact
  end

  post '/contact' do
    send_message
    flash[:notice] = "Message sent successfully"
    redirect '/contact'
  end

  not_found do
    slim :not_found
  end
end