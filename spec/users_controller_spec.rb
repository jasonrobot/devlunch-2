require './src/user.rb'
require './src/app_state.rb'
require './src/users_controller.rb'


RSpec.describe UsersController do
    context "during waiting" do
        before :example do
            AppState.state = :waiting
            @user = User.new 1, "test"
        end
        
        it "should not allow any status changes" do
            UsersController.signup @user, :joining
            expect(@user.status).to eq(:out)
            UsersController.signup @user, :voting
            expect(@user.status).to eq(:out)
        end
    end

    context "during voting" do
        before :example do
            AppState.state = :voting
            @user = User.new 1, "test"
        end
        
        it "should allow all status changes" do
            puts "im state #{AppState.load}"
            UsersController.signup @user, :joining
            expect(@user.status).to eq(:joining)
            UsersController.signup @user, :voting
            expect(@user.status).to eq(:voting)
        end

        it "should allow all user data to be changed" do

        end
    end

    context "during results pending" do
        before :example do            
            AppState.state = :results_pending
            @user = User.new 1, "test"
        end

        it "should allow status change between both OUT and JOINING" do
            @user.status = :out
            UsersController.signup @user, :joining
            expect(@user.status).to eq(:joining)
            UsersController.signup @user, :out
            expect(@user.status).to eq(:out)
        end

        it "should not allow change into or out of VOTING" do
            @user.status = :voting
            UsersController.signup @user, :out
            expect(@user.status).to eq(:voting)

            @user.status = :out
            UsersController.signup @user, :voting
            expect(@user.status).to eq(:out)
            
        end

        it "should allow pick to be changed" do

        end

        it "should not allow user data change" do
        end
    end

    context "during results final" do
        before :example do            
            AppState.state = :results_final
            @user = User.new 1, "test"
        end

        it "should not allow any state changes" do
        end

        it "should now allow any data changes" do
        end
    end
end