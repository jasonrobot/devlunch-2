require './src/app_state.rb'

RSpec.describe AppState do
  before :example do
    @state = AppState.new
  end

  context 'simply' do
    it 'can set to :waiting, :voting, :results_pending, and :results_final' do
      @state.value = :waiting
      expect(@state.value).to eq :waiting
      @state.value = :voting
      expect(@state.value).to eq :voting
      @state.value = :results_pending
      expect(@state.value).to eq :results_pending
      @state.value = :results_final
      expect(@state.value).to eq :results_final
    end

    it 'cannot be set to an invalid status' do
      @state.value = :poop
      expect(@state.value).not_to eq :poop
    end
  end
end
