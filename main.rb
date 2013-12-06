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

class Website < ApplicationController

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
      "<link href=\"\/#{sheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
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

  get('/styles.css'){ scss :styles }
  get('/javascripts/application.js'){ coffee :application }

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