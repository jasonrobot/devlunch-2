# this represents the state of the app
# TODO probably should just use an attr_accessor and name the field 'value'
class AppState
  @value = :waiting
  VALID_STATES = %i[waiting voting results_pending results_final].freeze

  def initialize
    @state = :waiting
  end

  attr_reader :value

  def value=(new_state)
    @value = new_state if VALID_STATES.include? new_state
  end
end
