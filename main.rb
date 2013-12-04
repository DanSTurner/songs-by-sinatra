require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require './song'

configure do
  enable :sessions
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  set :username,        'frank'
  set :password,        'sinatra'
  set :session_secret,  'kinda sucks'
end

configure :test do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
  set :username,        'frank'
  set :password,        'sinatra'
  set :session_secret,  'kinda sucks'
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
