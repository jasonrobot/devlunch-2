# make_users.rb
# make a bunch of dummy users for testing
#$LOAD_PATH = "../src"

require_relative '../src/user.rb'
require_relative '../src/redis_storage.rb'

# make some users for testing with
usernames = [
  'jason',
  'json',
  'beizhia',
  'peds',
  'jasontobot',
  'J',
  'Jeff',
  'John',
  'Hank',
  'Tom',
  'Anthony'
]
picks = [
  'dutch garden',
  'kbbq',
  'brewhouse'
]

storage = RedisStorage.new

usernames.each do |uname|
  u = User.new uname
  u.pick = picks.sample
  u.status = User::VALID_STATUSES.reject { |x| x == :winner }.sample

  # uri = URI('http://localhost:4567/')
  # Net::HTTP.start(uri.host, uri.port) do |http|
  # end

  storage.store u

  puts "#{u.name} is #{u.status} picked #{u.pick}"
end
