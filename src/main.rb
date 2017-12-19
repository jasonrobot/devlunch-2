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
  uname = params['uname']
  # need to load user by name
  storage = RedisStorage.new
  user = User.load storage, uname
  session = Session.new user.id
  storage.store session
  session.id
end

post '/createAccount' do
  return 'missing name' if params['name'].nil?
  puts 'create account'
  storage = RedisStorage.new
  name = params['name']
  user = User.new name
  storage.store user
  user.id
end

post '/signup' do
  # verify req'd params present, load them
  user_id = params['user_id']
  return if user_id.nil?
  operation = params['operation']
  return if operation.nil?
  # TODO: handle this check better
  return unless %w[out joining voting].include? operation

  store = RedisStorage.new
  user = User.load store, user_id
  state = AppState.load store
  UsersController.new(user, state).signup(operation.to_sym)
  store.store user
  # return 200 ok?
end

# TODO: what format should options come in?
post '/edit' do
  # load and verify params
  user_id = params['user_id']
  return if user_id.nil?
  # options = params['options']
  # TODO: make options into a hash
  fields = %w[name nickname pick]
  options = params.select { |k, _| fields.include? k }

  store = RedisStorage.new
  user = User.load store, user_id
  state = AppState.load store
  UsersController.new(user, state).update(options)
end

get '/users' do
  store = RedisStorage.new
  # this is ok here, because we don't need them parsed
  store.load_all(:user)
end

# FIXME: Move the logic out of this handler to somewhere that its testable
get '/users/*' do |option|
  return unless %w[voting joining].include?(option)

  store = RedisStorage.new
  users = User.load_all store
  users.select { |u| u.status == option.to_sym }.to_json
end
