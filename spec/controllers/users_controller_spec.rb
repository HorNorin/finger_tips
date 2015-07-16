require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET new" do
    it "should assign a new User @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    
    it "should render template new" do
      get :new
      expect(response).to render_template(:new)
    end
  end
  
  describe "POST create" do
    context "with valid attributes" do
      it "should create a new user" do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change(User, :count).by(1)
      end
      
      it "should sent activation instruction email" do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
      
      it "should redirect to login" do
        post :create, user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to(login_path)
      end
    end
    
    context "with invalid attributes" do
      it "should not save a new user" do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user, username: "")
        }.not_to change(User, :count)
      end
      
      it "should re-render new template" do
        post :create, user: FactoryGirl.attributes_for(:user, username: "")
        expect(response).to render_template(:new)
      end
    end
  end
end
