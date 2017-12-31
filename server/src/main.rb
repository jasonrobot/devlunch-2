# myapp.rb
require 'sinatra'
require 'json'
require './src/redis_storage.rb'
require './src/user.rb'
require './src/users_controller.rb'
require './src/session.rb'

def all_params?(params, *keys)
  keys.all? { |k| params.key? k }
end

get '/' do
  'Hello world!'
end

def login(uid)
  storage = RedisStorage.new
  # TODO: need to load user by name
  user = User.load storage, uid
  session = Session.new user.id
  storage.store session
  puts "sess id: #{session.session_id}"
  session.session_id.to_s
end

post '/login' do
  login params['user_id']
end

post '/createAccount' do
  return 'missing name' if params['name'].nil?
  storage = RedisStorage.new
  name = params['name']
  user = User.new name
  storage.store user
  login user.id
end

post '/signup' do
  # verify req'd params present, load them
  return unless all_params?(params, 'session_id', 'operation')
  session_id = params['session_id']
  operation = params['operation']
  # TODO: handle this check better
  return unless %w[out joining voting].include?(operation)

  store = RedisStorage.new
  session = Session.load store, session_id
  user = User.load store, session.user_id
  state = AppState.load store
  UsersController.new(user, state).signup(operation.to_sym)
  store.store user
end

post '/edit' do
  return unless all_params?(params, 'session_id')
  # load and verify params
  session_id = params['session_id']

  # filter out only the options we want
  fields = %w[name nickname pick]
  options = {}
  params.select { |k, _| fields.include? k }.each_key do |k|
    options[k.to_sym] = params[k]
  end

  store = RedisStorage.new
  session = Session.load store, session_id
  user = User.load store, session.user_id
  state = AppState.load store
  user = UsersController.new(user, state).update(options)
  store.store user
  user.to_json
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
