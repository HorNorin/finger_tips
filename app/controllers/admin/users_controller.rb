class Admin::UsersController < Admin::AdminController
  def index
    @users = User.where(role: User.roles[:normal])
                 .paginate(page: params[:page], per_page: 12)
                 .order("created_at DESC")
  end
  
  def destroy
    User.friendly.find(params[:id]).destroy
    flash[:success] = "One User has been delete from database."
    redirect_to admin_users_path
  end
end
