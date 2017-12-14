class User
  def initialize(name, id = nil, status = :out, nickname = '', pick = '')
    @id = id
    @status = status
    @name = name
    if nickname == ''
      @nickname = name
    else
      @nickname = nickname
    end
    @pick = ''
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

  attr_accessor :id
  attr_accessor :name
  attr_accessor :nickname
  attr_accessor :pick
end
