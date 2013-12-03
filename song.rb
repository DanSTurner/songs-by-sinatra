require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

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

DataMapper.finalize

get '/songs' do
  @songs = Song.all
  @title = "Songs"
  slim :songs
end

post '/songs' do
  @song = Song.create(params[:song])
  redirect "/songs/#{@song.id}"
end

get '/songs/new' do
  @song = Song.new
  @title = "Add a song"
  slim :new_song
end

get '/songs/:id' do
  @song = Song.get(params[:id])
  @title = ""
  slim :show_song
end

get '/songs/new' do
  @song = Song.new
  @title = "Add a Song"
  slim :new_song
end