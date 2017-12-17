# this represents the state of the app
# TODO probably should just use an attr_accessor and name the field 'value'
class AppState
  @value = :waiting
  VALID_STATES = %i[waiting voting results_pending results_final].freeze

  # If you're loading something from the DB, you'll probably need to use .to_sym on it
  def initialize(value = :waiting)
    @value = value
  end

  attr_reader :value

  def value=(new_state)
    @value = new_state if VALID_STATES.include? new_state
  end
end
