require 'random'

# This is the model for the session.
class Session
  def initialize(user_id)
    @user_id = user_id
    # session id needs to be something random
    @session_id = Random.new.rand
  end

  attr_accessor :user_id, :session_id
end
