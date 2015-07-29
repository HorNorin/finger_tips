class Api::LessonsController < ApplicationController
  def index
    @lessons = Lesson.with_translations(I18n.locale)
                     .paginate page: params[:page], per_page: 12
    render file: "api/lessons/lessons.json.erb", content_type: "application/json"
  end
  
  def trending
    @lessons = Lesson.with_translations(I18n.locale).order("created_at DESC").limit(12)
    render file: "api/lessons/trending.json.erb", content_type: "application/json"
  end
  
  def search
    if params[:name].blank?
      render json: nil
    else
      @lessons = Lesson.search(params[:name]).paginate(page: params[:page], per_page: 12)
      render file: "api/lessons/lessons.json.erb", content_type: "application/json"
    end
  end
end
