require 'json'
require './src/redis_storage.rb'
require './src/user.rb'

RSpec.describe RedisStorage do
  before :example do
    @store = RedisStorage.new
  end

  context 'with users' do
    it 'should store and load a user' do
      user_id = 4
      user = User.new 'tester', user_id
      @store.store user
      user_loaded = User.from_json @store.load(:user, user_id)
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
      user_loaded = User.from_json @store.load(:user, new_id)
      expect(user_loaded.name).to eq 'foobar'
    end

    it 'only stores User objects' do
      fu = FakeUser.new
      @store.store fu
      # expect(@store.load_all(:user).length).to eq 0
      expect(@store.load(:user, fu.id).nil?).to eq true
    end
  end

  context 'with AppState' do
    it 'should store and load app state' do
      state = AppState.new
      state.value = :voting
      @store.store state
      loaded_state = AppState.new((@store.load :app_state).to_sym)
      expect(loaded_state.value).to eq state.value
    end

    it 'should only ever store one' do
    end
  end
end

class FakeUser
  @id = 69
  @name = 'faker'

  attr_accessor :id, :name
end
