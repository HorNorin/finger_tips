class SessionsController < ApplicationController
  before_action :redirect_logged_in_user, except: :destroy
  before_action :redirect_not_logged_in_user, only: :destroy
  
  def new
  end
  
  def create
    @user = User.find_by email: params[:email]
    if @user && @user.authenticate(params[:password]) && @user.normal?
      if @user.account_activated?
        params[:remember_me] ? login_and_remember(@user) : login(@user)
        flash[:success] = "Welcome, #{@user.username}!"
        redirect_to root_path
      else
        flash.now[:error] = "You need to activate your account before you can login."
        render "new"
      end
    else
      flash.now[:error] = "Invalid email or password"
      render "new"
    end
  end
  
  def destroy
    logout
    flash[:success] = "Goodbye!"
    redirect_to root_path
  end
  
  private
  
  def redirect_logged_in_user
    if user_logged_in?
      flash[:error] = "You have already logged in."
      redirect_to root_path
    end
  end
  
  def redirect_not_logged_in_user
    unless user_logged_in?
      flash[:error] = "You need to login first before you can logout."
      redirect_to login_path
    end
  end
end
