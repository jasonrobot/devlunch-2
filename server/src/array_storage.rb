require_relative './user.rb'

# A storage backend that just keeps things in an array in memory. Good for testing.
class ArrayStorage
  @users = {}

  def initialize
    @next_user_id = 1
    @users = {}
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
    # return unless user.is_a? User
    if object.is_a? User
      object.id = @next_user_id if object.id.nil?
      @users[object.id] = object
      object.id
    end
  end

  def load(type, id)
    result = nil
    case type
    when :user
      result = @users[id]
    end
    result
  end

  def load_all(type)
    case type
    when :user
      @users
    end
  end
end
