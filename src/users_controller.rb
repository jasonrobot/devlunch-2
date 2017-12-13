class UsersController

    @@data_store

    def self.data_store=(ds)
        @@data_store = ds
    end

    def self.new_user (name)
        User.new @@data_store.next_user_id, name
    end
    
    def self.signup (user, operation)
        #operation = operation.to_sym        
        app_state = AppState.load

        case app_state
        when :waiting, :results_final
            #no transitions allowed!
        when :voting
            #all transitions allowed!
            user.status = operation
        when :results_pending
            #:out <-> :joining only!
            if (user.status != :voting) && (operation == :out || operation == :joining)
                user.status = operation
            else
                #return error
            end
        end

        #user.save
        user
    end

    def self.update (user, options)
        app_state = AppState.load
        #should check the formatting of options here, keys need to be symbols

        case app_state
        when :waiting, :voting
            #all changes allowed
            user.update options
        when :results_pending
            puts "in pending!"
            #only pick can be changed
            options.select! {|k, _| k == :pick}
            puts "updating with #{options}"
            user.update options
        when :results_final
            #no changes allowed!
        end
    end
end