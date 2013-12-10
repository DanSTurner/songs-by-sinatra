require 'sinatra/base'
require './sinatra/auth'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  register Sinatra::Flash
  register Sinatra::Auth

end