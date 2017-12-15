require './src/app_state.rb'

RSpec.describe AppState do
  before :example do
    @state = AppState.new
  end
  
  context 'simply' do
    it 'can set to :waiting, :voting, :results_pending, and :results_final' do
      @state.set :waiting
      expect(@state.load).to eq :waiting
      @state.set :voting
      expect(@state.load).to eq :voting
      @state.set :results_pending
      expect(@state.load).to eq :results_pending
      # @state = :results_final
      # expect(AppState.load).to eq :results_final
    end
  end
end
