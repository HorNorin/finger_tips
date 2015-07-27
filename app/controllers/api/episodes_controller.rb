class Api::EpisodesController < ApplicationController
  def index
    @episodes = Episode.includes(:lesson).paginate(page: params[:page], per_page: 12)
    render file: "api/episodes/episodes.json.erb", content_type: "application/json"
  end
  
  def search
    if params[:title].blank?
      render json: nil
    else
      @episodes = Episode.where("title LIKE ?", "#{params[:title]}%").includes(:lesson)
                         .paginate(page: params[:page], per_page: 12)
      render file: "api/episodes/episodes.json.erb", content_type: "application/json"
    end
  end
end
