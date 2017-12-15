require_relative './user.rb'

class ArrayStorage
  @users = {}

  def initialize
    @next_id = 0
    @users = {}
  end

  def next_user_id
    id = @next_id
    @next_id = id + 1
    id
  end

  def store_user(user)
    #@users[user.id] = user if (user.is_a? User) && !user.id.nil?
    return unless user.is_a? User
    return if user.id.nil?
    user.id = next_user_id
    @users[user.id] = user
    user.id
  end

  def load_user(id)
    @users[id]
  end

  def load_all_users
    @users
  end
end
