require 'rails_helper'

RSpec.describe EpisodesController, type: :controller do
  describe "GET index" do
    it "should render index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
  
  describe "GET show" do
    it "should render index template" do
      get :show, id: FactoryGirl.create(:episode)
      expect(response).to render_template(:show)
    end
  end
end
