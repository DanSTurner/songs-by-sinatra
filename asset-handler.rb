require 'sinatra/base'

class AssetHandler < Sinatra::Base
  configure do
    set :views, File.dirname(__FILE__) + '/assets'
    set :jsdir, 'js'
    set :cssdir, 'css'
    enable :coffeescript
    set :cssengine, 'scss'
    set :start_time, Time.now
  end

  get '/javascripts/*.js' do
    pass unless settings.coffeescript?
    last_modified settings.start_time
    etag settings.start_time.to_s
    cache_control :public, :must_validate
    coffee (settings.jsdir + '/' + params[:splat].first).to_sym
  end

  get '/*.css' do
    last_modified settings.start_time
    etag settings.start_time.to_s
    cache_control :public, :must_validate
    send(settings.cssengine, (settings.cssdir + '/' + params[:splat].first).to_sym)
  end
end