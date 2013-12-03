require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'

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

not_found do
  @title = "Page Not Found"
  slim :not_found
end