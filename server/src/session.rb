# This is the model for the session.
# Basically, it just maps a session id onto a user id
# FIXME sinatra has its own session management code, please use it
class Session
  def initialize(user_id, session_id = nil)
    @user_id = user_id
    # session id needs to be something random
    @session_id = if session_id.nil?
                    Random.new.rand(2**32)
                  else
                    session_id
                  end
  end

  def self.load(store, id)
    user_id = store.load :session, id
    puts "loaded user #{user_id}"
    new(user_id, id)
  end

  attr_accessor :user_id, :session_id
end
