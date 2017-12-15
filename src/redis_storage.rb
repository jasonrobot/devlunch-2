require 'redis'

# Storage backend using redis
class RedisStorage
  def initialize
    @next_id = 1
    # make a connection
    @redis = Redis.new#(host: 'localhost', port: 6379, db: 0)
  end

  def next_user_id
    id = @next_id
    @next_id = id + 1
    id
  end

  def store_user(user)
    # @users[user.id] = user if (user.is_a? User) && !user.id.nil?
    return unless user.is_a? User
    return if user.id.nil?
    user.id = next_user_id
    @redis.set user.id, user.to_json
    user.id
  end

  def load_user(id)
    user_json = @redis.get id
  end

  def load_all_users
    @users
  end
end
