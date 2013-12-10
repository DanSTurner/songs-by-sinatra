require 'sinatra/base'

class AssetHandler < Sinatra::Base
  configure do
    set :views, File.dirname(__FILE__) + '/assets'
    set :jsdir, 'js'
    set :cssdir, 'css'
    enable :coffeescript
    set :cssengine, 'scss'
  end

  get '/javascripts/*.js' do
    pass unless settings.coffeescript?
    coffee (settings.jsdir + '/' + params[:splat].first).to_sym
  end

  get '/*.css' do
    send(settings.cssengine, (settings.cssdir + '/' + params[:splat].first).to_sym)
  end
end