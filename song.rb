require 'sinatra/base'
require 'data_mapper'
require 'slim'
require 'sass'
require 'sinatra/flash'
require './sinatra/auth'
require './applicationcontroller'

DataMapper.finalize.auto_upgrade!

class Song
  include DataMapper::Resource
  property :id,           Serial
  property :title,        String
  property :lyrics,       Text
  property :length,       Integer
  property :released_on,  Date
  property :likes,        Integer, :default => 0

  def released_on=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

module SongHelpers
  # unnecessary abstraction
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.get(params[:id])
  end

  # another unnecessary abstraction
  def create_song
    @song = Song.create(params[:song])
  end
end

class SongController < ApplicationController
  enable :sessions
  enable :method_override

  configure do
    enable :sessions
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  end

  configure :test do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
  end

  helpers SongHelpers

  before do
    set_title
  end

  def css(*stylesheets)
    stylesheets.map do |sheet|
      "<link href=\"\/#{sheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def js(*scripts)
    scripts.map do |script|
      "<script src=\"/javascripts/#{script}.js\"></script>"
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
    find_songs
    @title = "Songs"
    slim :songs
  end

  post '/' do
    flash[:notice] = "Song successfully added" if create_song
    redirect "/#{@song.id}"
  end

  get '/new' do
    protected!
    @song = Song.new
    @title = "Add a song"
    slim :new_song
  end

  get '/:id' do
    @song = find_song
    @title = ""
    slim :show_song
  end

  put '/:id' do
    protected!
    @song = find_song
    if @song.update(params[:song])
      flash[:notice] = "Song successfully updated"
    end
    redirect ''
  end

  delete '/:id' do
    protected!
    if @song = find_song.destroy
      flash[:notice] = "Song successfully deleted"
    end
    redirect ''
  end

  get '/:id/edit' do
    protected!
    @song = find_song
    @title = "Edit #{@song.title}"
    slim :edit_song
  end

  post '/:id/like' do
    @song = find_song
    @song.likes = @song.likes.next
    @song.save
    redirect "/#{@song.id}" unless request.xhr?
    slim :like, :layout => false
  end
end