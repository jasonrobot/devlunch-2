require './src/user.rb'

RSpec.describe User do
    it "should default status to :out" do
        @user = User.new 1, "test"
        expect(@user.status).to eq :out
    end

    it "should not allow invalid statuses" do
        @user = User.new 1, "test"
        @user.status = :foobar
        expect(@user.status).not_to eq 4
    end

    describe "update" do
        before :example do
            @user = User.new 1, "test"
        end

        it "should allow data to be set from a hash" do
            @user.update({name: "foo", nickname: "bar", pick: "baz", status: :voting})
            expect(@user.name).to eq "foo"
            expect(@user.nickname).to eq "bar"
            expect(@user.pick).to eq "baz"
            expect(@user.status).to eq :voting
        end
    
        it "should ignore invalid hash keys" do
            @user.update({blah: "test"})
            #what expectations should be set here? Maybe that there's no change?
        end

        it "should not allow invalid statuses" do
            @user.status = :out
            @user.update({status: :foobar})
            expect(@user.status).to eq :out
        end
    end

end
