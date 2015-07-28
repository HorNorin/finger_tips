class Admin::EpisodesController < Admin::AdminController
  before_action :set_episode, except: [:index, :new, :create]
  
  def index
    @episodes = Episode.includes(:lesson).paginate(page: params[:page], per_page: 12).order("created_at DESC")
  end
  
  def new
    @episode = Episode.new
  end
  
  def create
    @episode = Episode.new episode_params
    if @episode.save
      flash[:success] = "One episode has been saved to the database."
      redirect_to new_admin_episode_path
    else
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    if @episode.update_attributes episode_params
      flash[:success] = "Update success."
      redirect_to admin_episodes_path
    else
      render "edit"
    end
  end
  
  def destroy
    @episode.destroy
    flash[:success] = "One episode has been delete from database."
    redirect_to admin_episodes_path
  end
  
  private
  
  def set_episode
    @episode = Episode.friendly.find params[:id]
  end
  
  def episode_params
    params.require(:episode).permit(
      :title,
      :image,
      :duration,
      :lesson_id,
      :youtube_url,
      :description
    )
  end
end
