require './src/user.rb'
require './src/app_state.rb'
require './src/users_controller.rb'
require './src/array_storage.rb'

RSpec.describe UsersController do
  before :example do
    @user = User.new 1, 'test'
    @app_state = AppState.new
    @users_controller = UsersController.new @user, @app_state
  end

  context 'during waiting' do
    before :example do
      @users_controller.state = AppState.new :waiting
    end

    it 'should not allow any status changes' do
      @users_controller.signup :joining
      expect(@user.status).to eq(:out)
      @users_controller.signup :voting
      expect(@user.status).to eq(:out)
    end
  end

  context 'during voting' do
    before :example do
      @users_controller.state = AppState.new :voting
    end

    it 'should allow all status changes' do
      @users_controller.signup :joining
      expect(@user.status).to eq(:joining)
      @users_controller.signup :voting
      expect(@user.status).to eq(:voting)
    end

    it 'should allow all user data to be changed' do
    end
  end

  context 'during results pending' do
    before :example do
      @users_controller.state = AppState.new :results_pending
    end

    it 'should allow status change between both OUT and JOINING' do
      @user.status = :out
      @users_controller.signup :joining
      expect(@user.status).to eq(:joining)
      @users_controller.signup :out
      expect(@user.status).to eq(:out)
    end

    it 'should not allow change into or out of VOTING' do
      @user.status = :voting
      @users_controller.signup :out
      expect(@user.status).to eq(:voting)

      @user.status = :out
      @users_controller.signup :voting
      expect(@user.status).to eq(:out)
    end

    it 'should allow pick to be changed' do
      @users_controller.update pick: 'food'
      expect(@user.pick).to eq 'food'
    end

    it 'should not allow user data change' do
      @users_controller.update name: 'foo', nickname: 'bar'
      expect(@user.name).not_to eq 'foo'
      expect(@user.name).not_to eq 'bar'
    end
  end

  context 'during results final' do
    before :example do
      @users_controller.state = AppState.new :results_final
    end

    it 'should not allow any state changes' do
    end

    it 'should now allow any data changes' do
    end
  end
end
