require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/extension'

module Auth
  extend Sinatra::Extension
  module Helpers
    def authorized?
      session[:admin]
    end

    def protected!
      halt 401, slim(:unauthorized) unless authorized?
    end
  end

  helpers Helpers

  enable :sessions

  set :username => 'frank',
      :password => 'sinatra'

  get '/login' do
    slim :login
  end

  post '/login' do
    if params[:username] == settings.username && params[:password] == settings.password
      session[:admin] = true
      flash[:notice] = "Welcome #{settings.username}, you logged in successfully"
      redirect '/songs'
    else
      flash[:notice] = 'Username or password is incorrect - please try again'
      redirect '/login'
    end
  end

  get '/logout' do
    session[:admin] = nil
    flash[:notice] = 'You are now logged out'
    redirect '/'
  end
end
register Auth