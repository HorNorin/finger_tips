require 'rails_helper'

RSpec.describe EpisodesController, type: :controller do
  describe "GET index" do
    it "should render index template" do
      get :index, lesson_id: 1
      expect(response).to render_template(:index)
    end
  end
  
  describe "GET show" do
    it "should render index template" do
      episode = FactoryGirl.create(:episode)
      get :show, id: episode, lesson_id: episode.lesson_id
      expect(response).to render_template(:show)
    end
  end
end
