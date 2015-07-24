class Api::EpisodesController < ApplicationController
  def index
    @episodes = Episode.includes(:lesson).paginate(page: params[:page], per_page: 12)
    # render json: {
    #   episodes: @episodes,
    #   per_page: @episodes.per_page,
    #   current: @episodes.current_page,
    #   nextPage: @episodes.next_page,
    #   prevPage: @episodes.previous_page,
    #   totalPages: @episodes.total_pages
    # }
    render file: "api/episodes/episodes.json.erb", content_type: "application/json"
  end
  
  def search
    if params[:title].blank?
      render json: nil
    else
      @episodes = Episode.where("title LIKE ?", "#{params[:title]}%").includes(:lesson)
                         .paginate(page: params[:page], per_page: 12)
      # render json: {
      #   episodes: @episodes,
      #   perPage: @episodes.per_page,
      #   current: @episodes.current_page,
      #   nextPage: @episodes.next_page,
      #   prevPage: @episodes.previous_page,
      #   totalPages: @episodes.total_pages
      # }
      render file: "api/episodes/episodes.json.erb", content_type: "application/json"
    end
  end
end
