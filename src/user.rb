class User
    OUT = 0
    JOINING = 1
    VOTING = 2

    def initialize (name)
        @status = OUT
        @name = name
        @nickname = name
        @pick = ''
    end

    attr_reader :status

    def status=(new_status)
        if (User.constants.map {|x| User.const_get x}).include? new_status
            @status = new_status
        end
    end
    
    attr_accessor :name
    attr_accessor :nickname
    attr_accessor :pick
end