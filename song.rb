require 'data_mapper'

configure do
  enable :sessions
  set :username,        'frank'
  set :password,        'sinatra'
  set :session_secret,  'kinda sucks'
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

DataMapper.finalize.auto_migrate!

class Song
  include DataMapper::Resource
  property :id,           Serial
  property :title,        String
  property :lyrics,       Text
  property :length,       Integer
  property :released_on,  Date

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

helpers SongHelpers

get '/songs' do
  find_songs
  @title = "Songs"
  slim :songs
end

post '/songs' do
  create_song
  redirect "/songs/#{@song.id}"
end

get '/songs/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @song = Song.new
  @title = "Add a song"
  slim :new_song
end

get '/songs/:id' do
  @song = find_song
  @title = ""
  slim :show_song
end

put '/songs/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  @song = find_song
  @song.update(params[:song])
  redirect '/songs'
end

delete '/songs/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  @song = find_song.destroy
  redirect '/songs'
end

get '/songs/:id/edit' do
  halt(401,'Not Authorized') unless session[:admin]
  @song = find_song
  @title = "Edit #{@song.title}"
  slim :edit_song
end
