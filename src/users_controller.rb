# This is the interface for manipulating a user object
# TODO see if this can be moved into User
class UsersController
  def initialize(user, app_state)
    @user = user
    @state = app_state
  end

  # TODO: something
  attr_accessor :state

  # signup - change the status field of a user
  def signup(operation)
    case @state.value
    # when :waiting, :results_final
    # no transitions allowed!
    when :voting
      # all transitions allowed!
      @user.status = operation
    when :results_pending
      #:out <-> :joining only!
      if (@user.status != :voting) && (operation == :out || operation == :joining)
        @user.status = operation
      end
    end

    @user
  end

  def update(options)
    # should check the formatting of options here, keys need to be symbols
    # take no action in :results_final state
    case @state.value
    when :waiting, :voting
      # all changes allowed
      @user.update options
    when :results_pending
      # only pick can be changed
      options.select! { |k, _| k == :pick }
      @user.update options
    end
  end
end
