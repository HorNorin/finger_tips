class EpisodesController < ApplicationController
  def index
  end
  
  def show
    lesson = Lesson.friendly.find params[:lesson_id]
    @episode = lesson.episodes.friendly.find(params[:id])
  end
end
