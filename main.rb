require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  @title = "Home"
  erb :home
end

get '/about' do
  @title = "about"
  erb :about
end

get '/contact' do
  @title = "Contact"
  erb :contact
end

not_found do
  @title = "Page Not Found"
  erb :not_found
end