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
        when :waiting
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
        when :results_final
            #no transitions allowed!
        end

        #user.save
        user
    end
end