# myapp.rb
require 'sinatra'
require 'json'
require './src/redis_storage.rb'
require './src/user.rb'
require './src/users_controller.rb'
require './src/session.rb'
require 'sinatra/cross_origin'

# before do
#   headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
#   headers['Access-Control-Allow-Origin'] = 'http://localhost:3000,'
#   headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
#   headers['Access-Control-Allow-Credentials'] = 'true'
# end

before do
  cross_origin
end

# configure do
#   enable :cross_origin
# end

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
  # "please just take some data"
end

post '/login' do
  puts 'we did at least hit login'

  login params['username']
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
  # return unless all_params?(params, 'operation')
  session_id = request.env['session']
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
  # return unless all_params?(request.env, 'session_id')
  # load and verify params
  session_id = request.env['session']

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

get '/me' do
  session_id = request.env['session']
  puts request.env.keys
  store = RedisStorage.new

  puts
  session = Session.load store, session_id
  user = User.load store, session.user_id
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

# this will return the status of the app and some related info
# waiting: how long till next vote
# voting: who is coming (+1/join), how long till pick
# results_*: who won, their pick, who's going (+1/join)
get '/status' do
  response = {}

  store = RedisStorage.new
  state = AppState.load store

  response[:status] = state.value

  case state.value
  when :waiting
    response[:timeleft] = 'cant calculate times yet'
  when :voting
    all_users = User.load_all store
    response[:voting] = all_users.select { |u| u.status == :voting }
    response[:joining] = all_users.select { |u| u.status == :joining }
    response[:timeleft] = 'cant calculate times yet'
  when :results_pending, :results_final
    all_users = User.load_all store
    response[:voting] = all_users.select { |u| u.status == :voting }
    response[:joining] = all_users.select { |u| u.status == :joining }
    response[:winner] = all_users.select { |u| u.status == :winner }
  end

  response.to_json
end
