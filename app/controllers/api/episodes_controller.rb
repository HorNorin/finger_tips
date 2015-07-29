class Api::EpisodesController < ApplicationController
  def index
    @episodes = Episode.with_translations(I18n.locale)
                       .includes(:lesson)
                       .paginate(page: params[:page], per_page: 12)
    render file: "api/episodes/episodes.json.erb", content_type: "application/json"
  end
  
  def trending
    @episodes = Episode.with_translations(I18n.locale).order("created_at DESC").limit(12)
    render file: "api/episodes/trending.json.erb", content_type: "application/json"
  end
  
  def search
    if params[:title].blank?
      render json: nil
    else
      @episodes = Episode.search(params[:title])
                         .includes(:lesson)
                         .paginate(page: params[:page], per_page: 12)
      render file: "api/episodes/episodes.json.erb", content_type: "application/json"
    end
  end
end
