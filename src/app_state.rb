# this represents the state of the app
class AppState
  @state = :waiting

  def set(new_state)
    @state = new_state
  end

  def load
    @state
  end
end
