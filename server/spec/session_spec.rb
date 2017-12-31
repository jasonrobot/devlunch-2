require './src/session.rb'

RSpec.describe Session do
  it 'should create a session with a random ID' do
    s1 = Session.new 1
    s2 = Session.new 2
    expect(s1.session_id).not_to eq(s2.session_id)
  end
end
