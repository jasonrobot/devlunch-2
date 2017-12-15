require 'redis'
require './src/user.rb'
require './src/app_state.rb'

# Storage backend using redis
class RedisStorage
  def initialize
    @next_user_id = 1
    # make a connection
    @redis = Redis.new # (host: 'localhost', port: 6379, db: 0)
  end

  def next_id(type)
    case type
    when :user
      id = @next_user_id
      @next_user_id = id + 1
      id
    end
  end

  # Store an object. Don't worry about type, just toss it on in.
  def store(object)
    # TODO: return success or failure
    # @users[user.id] = user if (user.is_a? User) && !user.id.nil?
    if object.is_a? User
      object.id = @next_user_id if object.id.nil?
      @redis.set "user:#{object.id}", object.to_json
      object.id
    elsif object.is_a? AppState
      @redis.set 'appstate', object.value.to_s
    end
  end

  def load(type, id = nil)
    result = nil
    case type
    when :user
      return if id.nil?
      result_json = @redis.get "user:#{id}"
      return if result_json.nil?
      result = User.from_json id, result_json
    when :app_state
      result = AppState.new
      result.value = @redis.get('appstate').to_sym
    end
    result
  end

  def load_all(type)
    case type
    when :user
      @redis.scan 0, @match => 'user:*'
    end
  end

  def reset
    @redis.flushdb
  end
end
