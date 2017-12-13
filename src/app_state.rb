class AppState
    @@state = :waiting

    def self.load
        @@state
    end

    def self.state=(new_state)
        @@state = new_state
    end
end
