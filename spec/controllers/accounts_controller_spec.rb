require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe "GET activate" do
    before(:each) { @user = FactoryGirl.create :user }
    
    context "with valid token" do
      before(:each) { get :activate, user_id: @user.id, token: @user.activation_token }
      
      it "should set account_activated to true" do
        expect(@user.reload.account_activated).to eq(true)
      end
      
      it "should set activation_token to nil" do
        expect(@user.reload.activation_token).to be_nil
      end
    end
    
    context "with invalid token" do
      it "should raise exception" do
        expect {
          get :activate, user_id: @user.id, token: "asdasd"
        }.to raise_error(ActionController::RoutingError)
        
        expect(@user.reload.account_activated).not_to eq(true)
        expect(@user.reload.activation_token).not_to be_nil
      end
    end
  end
end
