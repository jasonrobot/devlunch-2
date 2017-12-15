# User object
class User
  def initialize(name, id = nil, status = :out, nickname = '', pick = '')
    @id = id
    @status = status
    @name = name
    @nickname = (nickname == '' ? name : nickname)
    @pick = pick
  end

  def self.from_json(id, json)
    json = JSON.parse json
    new(json['name'],
        id,
        json['status'].to_sym,
        json['nickname'],
        json['pick'])
  end

  # update data from a hash
  # @id can't be updated though
  def update(data)
    @name = data[:name] unless data[:name].nil?
    @nickname = data[:nickname] unless data[:nickname].nil?
    @pick = data[:pick] unless data[:pick].nil?
  end

  attr_reader :status

  def status=(new_status)
    if %i[out voting joining].include? new_status
      @status = new_status
    else
      puts "invalid status #{new_status}"
    end
  end

  def to_json
    { 'name' => @name,
      'status' => @status,
      'nickname' => @nickname,
      'pick' => @pick }.to_json
  end

  attr_accessor :id
  attr_accessor :name
  attr_accessor :nickname
  attr_accessor :pick
end
