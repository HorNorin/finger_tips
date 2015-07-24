class Api::UsersController < ApplicationController
  def validate
    render json: User.where("email = ?", params[:email]).count == 0
  end
  
  def update
    flash[:success] = "Update success"
    current_user.update_attributes(user_params)
    render json: { path: account_path }
  end
  
  private
  
  def user_params
    params.require(:user).permit :email, :username, :password, :password_confirmation
  end
end
