require './src/redis_storage.rb'
require './src/user.rb'

RSpec.describe RedisStorage do
  before :example do
    @store = RedisStorage.new
  end
  
  xcontext 'integration' do
    it 'should store and load a user' do
      user_id = 4
      user = User.new 'tester', 4
      @store.store_user user
      user_loaded = @store.load_user user_id
      expect(user_loaded.name).to eq 'tester'
    end

    it 'should always return a new user_id' do
      id1 = @store.next_user_id
      id2 = @store.next_user_id
      expect(id1).not_to eq id2
    end

    it 'should set the id of a user and store it if id is nil' do
      user = User.new 'foobar'
      new_id = @store.store_user user
      expect(@store.load_all_users.length).to eq 1
      user_loaded = @store.load_user new_id
      expect(user_loaded.name).to eq 'foobar'
    end

    it 'only stores User objects' do
      @store.store_user FakeUser.new
      expect(@store.load_all_users.length).to eq 0
    end
  end
end

class FakeUser
  @id = 69
  @name = 'faker'

  attr_accessor :id, :name
end
