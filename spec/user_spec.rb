require './src/user.rb'

RSpec.describe User do
    context "in isolation" do
        it "should default status to OUT" do
            user = User.new 1, "test"
            expect(user.status).to eq :out
        end

        it "should not allow invalid statuses" do
            user = User.new 1, "test"
            user.status = :foobar
            expect(user.status).not_to eq 4
        end
    end
end
