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
    if user.is_a? User
      if user.id.nil?
        user.id = self.next_user_id
      end
      @users[user.id] = user
      return user.id
    end
  end

  def load_user(id)
    @users[id]
  end

  def load_all_users
    @users
  end
end
