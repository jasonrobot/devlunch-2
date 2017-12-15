class UsersController
  def initialize(state)
    @state = state
  end

  attr_accessor :state

  def signup(user, operation)
    # operation = operation.to_sym
    case @state
    when :waiting, :results_final
    # no transitions allowed!
    when :voting
      # all transitions allowed!
      user.status = operation
    when :results_pending
      #:out <-> :joining only!
      if (user.status != :voting) && (operation == :out || operation == :joining)
        user.status = operation
      else
        # return error
      end
    end

    user
  end

  def update(user, options)
    # should check the formatting of options here, keys need to be symbols
    case @state
    when :waiting, :voting
      # all changes allowed
      user.update options
    when :results_pending
      puts 'in pending!'
      # only pick can be changed
      options.select! { |k, _| k == :pick }
      puts "updating with #{options}"
      user.update options
    when :results_final
      # no changes allowed!
    end
  end
end
