# myapp.rb
require 'sinatra'
require 'json'
require './src/array_storage.rb'

@storage = ArrayStorage.new

get '/' do
  'Hello world!'
end

def post_login; end

post '/login' do
end

def create_account(params)
  name = params['name']
  user = User.new name
  @storage.store_user user
end

post '/createAccount' do
  create_account params
end

get '/signup/*' do |operation|
  UsersController.signup params['user_id'], operation
end

def get_users(option, _params)
  User.get(option.to_sym).to_json
end

get '/users/*' do |option|
  get_users option, params
end
