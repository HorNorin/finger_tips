class Admin::LessonsController < Admin::AdminController
  before_action :set_lesson, except: [:index, :new, :create]
  
  def index
    @lessons = Lesson.paginate(page: params[:page], per_page: 12).order("created_at DESC")
  end
  
  def new
    @lesson = Lesson.new
  end
  
  def create
    @lesson = Lesson.new lesson_params
    if @lesson.save
      flash[:success] = "One lesson has been saved to the database."
      redirect_to new_admin_lesson_path
    else
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    if @lesson.update_attributes lesson_params
      flash[:success] = "Update success."
      redirect_to admin_lessons_path
    else
      render "edit"
    end
  end
  
  def destroy
    @lesson.destroy
    flash[:success] = "One lesson has been delete from database."
    redirect_to admin_lessons_path
  end
  
  private
  
  def set_lesson
    @lesson = Lesson.friendly.find params[:id]
  end
  
  def lesson_params
    params.require(:lesson).permit(
      :name,
      episodes_attributes: [
        :title,
        :image,
        :duration,
        :lesson_id,
        :description,
        :youtube_url
      ]
    )
  end
end
