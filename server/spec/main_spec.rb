require './src/redis_storage.rb'
require './src/user.rb'
require './src/users_controller.rb'
require './src/session.rb'

RSpec.describe 'misc' do
  describe 'things' do
    it 'should store and load users with sessions' do
      redis = RedisStorage.new
      user = User.new 'test'
      redis.store user
      session = Session.new user.id
      redis.store session

      sess2 = Session.load redis, session.session_id
      puts sess2.session_id
      puts sess2.user_id
      user2 = User.load redis, sess2.user_id
      expect(user2).not_to eq nil
    end
  end
end
