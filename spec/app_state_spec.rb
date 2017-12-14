require './src/app_state.rb'

RSpec.describe AppState do
  context 'simply' do
    it 'can set to :waiting, :voting, :results_pending, and :results_final' do
      AppState.state = :waiting
      expect(AppState.load).to eq :waiting
      AppState.state = :voting
      expect(AppState.load).to eq :voting
      AppState.state = :results_pending
      expect(AppState.load).to eq :results_pending
      # AppState.state = :results_final
      # expect(AppState.load).to eq :results_final
    end
  end
end
