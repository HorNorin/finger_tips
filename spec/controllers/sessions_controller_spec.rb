require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    it "should assign a new User @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    
    it "should render new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end
end
