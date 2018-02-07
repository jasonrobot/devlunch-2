require 'redis'
require_relative 'user.rb'
require_relative 'app_state.rb'

# Storage backend using redis
# everything in here needs to return json. It's up to the app to reify
class RedisStorage
  def initialize
    # make a connection
    @redis = Redis.new # (host: 'localhost', port: 6379, db: 0)
    @next_user_id = @redis.get('next-user-id').to_i
    if @next_user_id.nil?
      @redis.set 'next-user-id', 1
      @next_user_id = 1
    end
  end

  def next_id(type)
    case type
    when :user
      id = @next_user_id
      @next_user_id = id + 1
      @redis.set 'next-user-id', @next_user_id
      id
    end
  end

  # Store an object. Don't worry about type, just toss it on in.
  # TODO: Could we move the storage logic into the model class?
  def store(object)
    # TODO: return success or failure
    if object.is_a? User
      object.id = next_id(:user) if object.id.nil?
      @redis.set "user:#{object.id}", object.to_json
      object.id
    elsif object.is_a? Session
      @redis.set "session:#{object.session_id}", object.user_id
      object.session_id
    elsif object.is_a? AppState
      @redis.set 'appstate', object.value.to_s
    end
  end

  def load(type, id = nil)
    case type
    when :user
      return if id.nil?
      load_user id
    when :session
      load_session id
    when :app_state
      load_app_state
    end
  end

  # this needs to return an array of objects, not an array of strings
  def load_all(type)
    case type
    when :user
      # use index 1 so as to not include the cursor
      # result = @redis.scan(0, match: 'user:*')[1].map do |k|
      result = @redis.keys('user:*').map do |k|
        puts "getting from key #{k}: #{@redis.get(k)}"
        JSON.parse(@redis.get(k))
      end
      result.to_json
    end
  end

  private

  def load_user(id)
    @redis.get "user:#{id}"
  end

  def load_session(id)
    puts "getting id #{id}"
    result = @redis.get "session:#{id}"
    puts "got from redis #{result}"
    result
  end

  # This is a bit of a special one, because its just a value, not a json object
  def load_app_state
    @redis.get 'appstate'
  end

  def reset
    @redis.flushdb
  end
end
