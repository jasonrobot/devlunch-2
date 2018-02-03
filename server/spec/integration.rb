require 'curb'

RSpec.describe 'integration' do
  @url = 'http://localhost'
  @session = Curl.post("#{@url}/createAccount", name: 'tester')
  @set_session = lambda do |http|
    http.headers['session'] = @session
  end

  describe 'getting info' do
    it 'should let a user query themselves' do
      resp = Curl.get("#{@url}/me", &set_session)
      puts resp
    end
  end

  describe 'signing up' do
    # before :example do
    #   Curl.post("#{@url}/login", id: @user_id)
    # end

    it 'should let the user change status' do
      Curl.post("#{@url}/signup", operation: 'joining', &set_session)
    end
  end
end
