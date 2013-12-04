require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require './song'

helpers do
  def css(*stylesheets)
    stylesheets.map do |sheet|
      "<link href=\"\/#{sheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path = '/')
    "current" if (request.path == path || request.path == path + "/")
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
