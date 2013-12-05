require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/flash'
require 'slim'
require 'sass'
require 'pony'
require './song'

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
      :domain               => 'heroku.com'
    }
  }
end

helpers do
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
end

get('/styles.css'){ scss :styles }

get '/' do
  @title = "Home"
  slim :home
end

get '/about' do
  @title = "About"
  slim :about
end

get '/contact' do
  @title = "Contact"
  slim :contact
end

post '/contact' do
  send_message
  flash[:notice] = "Message sent successfully"
  redirect '/contact'
end

get '/login' do
  @title = "Login"
  slim :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect '/songs'
  else
    @title = "Try again"
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

not_found do
  @title = "Page Not Found"
  slim :not_found
end
