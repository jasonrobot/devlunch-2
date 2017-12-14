# myapp.rb
require 'sinatra'
require 'json'

get '/' do
  'Hello world!'
end

def post_login; end

post '/login' do
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
