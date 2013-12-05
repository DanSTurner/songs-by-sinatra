require 'data_mapper'

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :test do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
end

DataMapper.finalize.auto_upgrade!

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
  flash[:notice] = "Song successfully added" if create_song
  redirect "/songs/#{@song.id}"
end

get '/songs/new' do
  protected!
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
  protected!
  @song = find_song
  if @song.update(params[:song])
    flash[:notice] = "Song successfully updated"
  end
  redirect '/songs'
end

delete '/songs/:id' do
  protected!
  if @song = find_song.destroy
    flash[:notice] = "Song successfully deleted"
  end
  redirect '/songs'
end

get '/songs/:id/edit' do
  protected!
  @song = find_song
  @title = "Edit #{@song.title}"
  slim :edit_song
end
