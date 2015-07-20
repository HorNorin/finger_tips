class PasswordResetsController < ApplicationController
  before_action :redirect_logged_in_user
  
  def new
  end
  
  def create
    user = User.find_by email: params[:email]
    if user && user.update_attributes(password_reset_token: SecureRandom.urlsafe_base64)
      Notifier.reset_password(user).deliver_now
      flash[:success] = "An instruction on how to reset your password has been sent to your email."
      redirect_to root_path
    else
      flash[:error] = "Email does not exists!"
      render "new"
    end
  end
  
  def edit
    @user = User.find params[:user_id]
    if !@user || @user.password_reset_token != params[:token]
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  
  def update
    user = User.find params[:user_id]
    user.password = params[:password]
    user.password_confirmation = params[:password]
    user.password_reset_token = nil
    
    if user && user.save
      flash[:success] = "Your password has been changed successfully."
      redirect_to login_path
    else
      flash.now[:error] = "Password is not valid"
      render "edit"
    end
  end
  
  private
  
  def redirect_logged_in_user
    redirect_to root_path if user_logged_in?
  end
end
