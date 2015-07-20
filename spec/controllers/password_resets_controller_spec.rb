require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  context "user has already logged in" do
    it "should redirect to home page" do
      user = FactoryGirl.create :user
      login user
      
      get :new
      expect(response).to redirect_to(root_path)
    end
  end
  
  context "user has not logged in" do
    describe "GET new" do
      it "should render template new" do
        get :new
        expect(response).to render_template(:new)
      end
    end
    
    describe "POST create" do
      before(:each) { @user = FactoryGirl.create :user, account_activated: true }
      
      context "with valid email" do
        it "should send reset password instruction" do
          expect {
            post :create, email: @user.email
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
        
        it "should generate new password_reset_token" do
          old_token = @user.password_reset_token
          post :create, email: @user.email
          expect(@user.reload.password_reset_token).to_not eq(old_token)
        end
      end
      
      context "with invalid email" do
        it "should not send reset password instruction" do
          expect {
            post :create, email: "invalid@email.com"
          }.to_not change { ActionMailer::Base.deliveries.count }
        end
        
        it "should render new template" do
          post :create, email: "invalid@email.com"
          expect(response).to render_template(:new)
        end
      end
    end
    
    describe "GET edit" do
      context "with valid reset token" do
        it "should render template edit" do
          user = FactoryGirl.create :user, password_reset_token: "12345"
          
          get :edit, { user_id: user.id, token: user.password_reset_token }
          expect(response).to render_template(:edit)
        end
      end
      
      context "with invalid reset token" do
        it "should raise error" do
          user = FactoryGirl.create :user, password_reset_token: "12345"
          
          expect {
            get :edit, user_id: user.id, token: "aaaaaa"
          }.to raise_error(ActionController::RoutingError)
        end
      end
    end
    
    describe "POST update" do
      context "with valid password" do
        it "should update new password" do
          user = FactoryGirl.create :user, password: "secret", password_confirmation: "secret"
          
          post :update, user_id: user.id, password: "1234567"
          expect(user.reload.send(:encrypt, "1234567")).to eq(user.password_hash)
        end
        
        it "should redirect to home page" do
          user = FactoryGirl.create :user
          
          post :update, user_id: user.id, password: "1234567"
          expect(response).to redirect_to(login_path)
        end
        
        it "should set password_reset_token to nil" do
          user = FactoryGirl.create :user, password_reset_token: "asdasdasd"
          
          post :update, user_id: user.id, password: "1234567"
          expect(user.reload.password_reset_token).to be_nil
        end
      end
      
      context "with invalid password" do
        it "should not update new passowrd" do
          user = FactoryGirl.create :user, password: "secret", password_confirmation: "secret"
          
          post :update, user_id: user.id, password: "1234"
          expect(user.reload.send(:encrypt, "1234")).to_not eq(user.password_hash)
          expect(user.reload.send(:encrypt, "secret")).to eq(user.password_hash)
        end
      end
    end
  end
end
