class User 
    def initialize (id, name)
        @id = id
        @status = :out
        @name = name
        @nickname = name
        @pick = ''
    end

    attr_reader :status

    def status=(new_status)
        if [:out, :voting, :joining].include? new_status
            @status = new_status
        else
            puts "invalid status #{new_status}"
        end
    end
    
    attr_accessor :id
    attr_accessor :name
    attr_accessor :nickname
    attr_accessor :pick
end