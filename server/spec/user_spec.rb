require './src/user.rb'

RSpec.describe User do
  context 'in isolation' do
    it 'should default status to :out' do
      @user = User.new 'test', 1
      expect(@user.status).to eq :out
    end

    it 'should not allow invalid statuses' do
      @user = User.new 'test', 1
      @user.status = :foobar
      expect(@user.status).not_to eq :foobar
    end
  end

  describe 'update' do
    before :example do
      @user = User.new 'test', 1
    end

    it 'should allow data to be set from a hash' do
      @user.update!(name: 'foo', nickname: 'bar', pick: 'baz')
      expect(@user.name).to eq 'foo'
      expect(@user.nickname).to eq 'bar'
      expect(@user.pick).to eq 'baz'
    end

    it 'should ignore invalid hash keys' do
      @user.update!(blah: 'test')
      # what expectations should be set here? Maybe that there's no change?
      expect(@user.blah).not_to eq 'test'
    end

    it 'should not allow status changes' do
      @user.status = :out
      @user.update!(status: :joining)
      expect(@user.status).to eq :out
    end
  end

  context 'being loaded' do
    before :example do
      @user = User.new('test', 1, :voting, 't', 'food')
    end

    it 'should load from json' do
      result = User.from_json @user.to_json
      expect(result.name).to eq @user.name
      expect(result.id).to eq @user.id
      expect(result.status).to eq @user.status
      expect(result.nickname).to eq @user.nickname
      expect(result.pick).to eq @user.pick
    end

    it 'should load multiple from json' do
      user1 = User.new 'foo', 3
      user2 = User.new 'bar', 5
      result = User.from_json_array([user1, user2].to_json)
      expect(result.length).to eq 2
      expect(result[0].name).to eq 'foo'
      expect(result[1].name).to eq 'bar'
    end
  end
end
