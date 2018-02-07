# main.cr
# for now, just creates some users

require "http/client"
require "json"

class User
    def initialize(name, id : (Int32|Nil), status = :out, nickname = "", pick = "")
        @id = id
        @status = status
        @name = name
        @nickname = (nickname == "" ? name : nickname)
        @pick = pick
    end

    VALID_STATUSES = %i[out voting joining winner]
    
    JSON.mapping(
        name: String,
        id: (Int32|Nil),
        status: String,
        nickname: String,
        pick: String
    )
end

response = HTTP::Client.get "http://localhost:4567/users"
puts response.body.lines



HTTP::Client.new ("http://localhost:4567") do |client|
#    client.post("/")
end