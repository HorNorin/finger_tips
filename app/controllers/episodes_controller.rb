class EpisodesController < ApplicationController
  def index
  end
  
  def show
    @episode = Episode.find params[:id]
  end
end
