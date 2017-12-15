# myapp.rb
require 'sinatra'
require 'json'
require './src/array_storage.rb'
require './src/redis_storage.rb'
require './src/user.rb'
require './src/users_controller.rb'

get '/' do
  'Hello world!'
end

post '/login' do
end

post '/createAccount' do
  return 'missing name' if params['name'].nil?
  puts 'create account'
  storage = RedisStorage.new
  name = params['name']
  user = User.new name
  storage.store user
end

get '/signup/*' do |operation|
  return if params['user_id'].nil?
  return unless %s(out joining voting).include? operation
  store = RedisStorage.new
  user_id = params['user_id']
  user = store.load :user, user_id
  users_controller = UsersController.new store.load(:app_state).value
  user = users_controller.signup user, operation.to_sym
  store.store user
end

get '/users' do
  store = RedisStorage.new
  store.load_all(:user).to_s
end

get '/users/*' do |option|
  store = RedisStorage.new
  users = store.load_all :user
end
