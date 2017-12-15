require 'redis'
require './src/user.rb'

# Storage backend using redis
class RedisStorage
  def initialize
    @next_user_id = 1
    # make a connection
    @redis = Redis.new #(host: 'localhost', port: 6379, db: 0)
  end

  def next_id(type)
    case type
    when :user
      id = @next_user_id
      @next_user_id = id + 1
      id
    end
  end

  def store(object)
    # @users[user.id] = user if (user.is_a? User) && !user.id.nil?
    if object.is_a? User
      object.id = @next_user_id if object.id.nil?
      @redis.set "user:#{object.id}", object.to_json
      object.id
    end
  end

  def load(type, id)
    result = nil
    case type
    when :user
      result_json = @redis.get "user:#{id}"
      puts result_json.to_s
      result = User.from_json id, result_json
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
