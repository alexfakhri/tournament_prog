require 'data_mapper'
require 'sinatra'
require 'rack-flash'
require './lib/player'
require_relative 'data_mapper_setup'
require_relative 'helpers/application'


enable :sessions
set :session_secret, 'super secret'
use Rack::Flash


get '/' do
	erb :index
end

get '/player/new' do
	@player = Player.new
  erb :"player/new"
end

post '/player' do
	@player = Player.new(email: params[:email],
					password: params[:password],
					password_confirmation: params[:password_confirmation])
	if @player.save
		session[:player_id] = @player.id
		redirect to('/')
	else
		flash[:errors]= @player.errors.full_messages
		erb :"player/new"
	end
end

get '/sessions/new' do
	erb :"sessions/new"
end

post '/sessions' do
	email, password = params[:email], params[:password]
	player = Player.authenticate(email, password)
	if player
		session[:player_id] = player.id
		redirect to('/')
	else
		flash[:errors] = ["The email or password is incorrect"]
		erb :"sessions/new"
	end
end

delete '/sessions' do
  flash[:notice] = "Goodbye!"
  session[:user_id] = nil
  redirect '/'
end 