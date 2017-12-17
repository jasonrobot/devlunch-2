# User object
class User
  def initialize(name, id = nil, status = :out, nickname = '', pick = '')
    @id = id
    @status = status
    @name = name
    @nickname = (nickname == '' ? name : nickname)
    @pick = pick
  end

  def self.load(storage, id)
    from_json storage.load :user, id
  end

  def self.load_all(storage)
    from_json_array storage.load_all :user
  end

  # TODO: I want both these json parsing methods to work the same
  # FIXME: make private
  def self.from_json(json)
    json = JSON.parse json
    new(json['name'],
        json['id'],
        json['status'].to_sym,
        json['nickname'],
        json['pick'])
  end

  # FIXME: make private
  def self.from_json_array(json)
    json = JSON.parse json
    json.map do |user_json|
      new(user_json['name'],
          user_json['id'],
          user_json['status'].to_sym,
          user_json['nickname'],
          user_json['pick'])
    end
  end

  # update data from a hash
  # @id can't be updated though
  # @status needs to be updated on its own
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

  def to_json(options = {})
    { 'name'     => @name,
      'id'       => @id,
      'status'   => @status,
      'nickname' => @nickname,
      'pick'     => @pick }.to_json
  end

  attr_accessor :id
  attr_accessor :name
  attr_accessor :nickname
  attr_accessor :pick
end
