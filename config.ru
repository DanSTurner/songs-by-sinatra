require 'sinatra/base'
require './main'
require './song'

run Sinatra::Application

map('/songs') { run SongController }
map('/') { run Website }