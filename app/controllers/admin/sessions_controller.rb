class Admin::SessionsController < ApplicationController
  before_action :reject_logged_in_user
  before_action :redirect_logged_in_admin, except: :destroy
  before_action :access_denied, only: :destroy
  
  layout "layouts/admin/application"
  
  def new
  end
  
  def create
    @user = User.find_by email: params[:email]
    if @user && @user.authenticate(params[:password]) && @user.admin?
      params[:remember_me] ? login_and_remember(@user) : login(@user)
      flash[:success] = "Welcome back, Sir!"
      redirect_to admin_root_path
    else
      flash.now[:error] = "Are you an admin?"
      render "new"
    end
  end
  
  def destroy
    logout
    flash[:success] = "Goodbye!"
    redirect_to admin_login_path
  end
  
  private
  
  def redirect_logged_in_admin
    if admin_logged_in?
      flash[:error] = "You have already logged in."
      redirect_to admin_root_path
    end
  end
  
  def reject_logged_in_user
    if user_logged_in?
      flash[:error] = "You don't have permission to access this page."
      redirect_to root_url(subdomain: false)
    end
  end
end
