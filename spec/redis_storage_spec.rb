require 'json'
require './src/redis_storage.rb'
require './src/user.rb'

RSpec.describe RedisStorage do
  before :example do
    @store = RedisStorage.new
  end

  context 'in isolation' do
    it 'should store and load a user' do
      user_id = 4
      user = User.new 'tester', 4
      @store.store user
      user_loaded = @store.load :user, user_id
      expect(user_loaded.name).to eq 'tester'
    end

    it 'should always return a new user_id' do
      id1 = @store.next_id :user
      id2 = @store.next_id :user
      expect(id1).not_to eq id2
    end

    it 'should set the id of a user and store it if id is nil' do
      user = User.new 'foobar'
      new_id = @store.store user
      # expect(@store.load_all(:user).length).to eq 1
      user_loaded = @store.load :user, new_id
      puts user_loaded.pick
      expect(user_loaded.name).to eq 'foobar'
    end

    it 'only stores User objects' do
      fu = FakeUser.new
      @store.store fu
      # expect(@store.load_all(:user).length).to eq 0
      expect(@store.load(:user, fu.id)).to eq nil
    end
  end
end

class FakeUser
  @id = 69
  @name = 'faker'

  attr_accessor :id, :name
end
