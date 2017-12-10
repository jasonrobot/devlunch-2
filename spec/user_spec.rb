require './src/user.rb'

RSpec.describe User, "foo" do
    context "hello" do
        it "should exist" do
            user = User.new "test"
            expect(user.status).to eq User::OUT
        end
    end

    context "in isolation" do
        it "should not allow invalid statuses" do
            user = User.new "test"
            user.status = 4
            expect(user.status).not_to eq 4
        end
    end

    context "during waiting" do
        it "should not allow any status changes" do
        end
    end

    context "during voting" do
        it "should allow all status changes" do
        end

        it "should allow all user data to be changed" do
        end

    end

    context "during results" do
        it "should allow status change between both OUT and JOINING" do
        end

        it "should not allow change into or out of VOTING" do
        end

        it "should allow pick to be changed" do
        end

        it "should not allow user data change" do
        end
    end


end
