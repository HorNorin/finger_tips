require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    context "user already logged in" do
      it "should redirect to home page" do
        user = FactoryGirl.create :user
        login user
        
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
    
    context "user has not logged in" do
      it "should render new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end
  
  describe "POST create" do
    before :each do
      @user = FactoryGirl.create :user,
              email: "norin@example.com",
              username: "norin",
              password: "secret",
              password_confirmation: "secret",
              account_activated: true
    end
    
    context "account is not activated" do
      it "should render template new" do
        @user.account_activated = false
        @user.save
        
        post :create, {email: @user.email, password: @user.password}
        expect(response).to render_template(:new)
      end
    end
    
    context "user has not logged in" do
      context "with valid credential" do
        it "should redirect to home page" do
          post :create, {email: "norin@example.com", password: "secret"}
          expect(response).to redirect_to(root_path)
        end
        
        it "should have user id in session" do
          post :create, {email: "norin@example.com", password: "secret"}
          expect(session[:user_id]).to eq(@user.id)
        end
      end
      
      context "with invalid credential" do
        it "should render new template" do
          post :create, {email: "wrong@email.com", password: "wrong password"}
          expect(response).to render_template(:new)
        end
      end
    end
    
    context "user has already logged in" do
      it "should redirect home page" do
        user = FactoryGirl.create :user
        login user
        
        post :create
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  describe "GET destroy" do
    context "user has already logged in" do
      before :each do
        user = FactoryGirl.create :user
        login user
      end
      
      it "should redirect to home page" do
        get :destroy
        expect(response).to redirect_to(root_path)
      end
      
      it "should remove user id from session" do
        get :destroy
        expect(session[:user_id]).to be_nil
      end
    end
    
    context "user has not logged in" do
      it "should redirect login page" do
        get :destroy
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
