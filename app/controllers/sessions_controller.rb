class SessionsController < ApplicationController
  before_action :redirect_logged_in_user, except: :destroy
  before_action :redirect_not_logged_in_user, only: :destroy
  
  def new
    session[:back] = request.referer
  end
  
  def create
    @user = User.find_by email: params[:email]
    if @user && @user.authenticate(params[:password]) && @user.normal?
      if @user.account_activated?
        params[:remember_me] ? login_and_remember(@user) : login(@user)
        flash[:success] = t("flash.sessions.login.success", username: @user.username)
        redirect_back_or root_path
      else
        flash.now[:error] = t("flash.sessions.login.activate_error")
        render "new"
      end
    else
      flash.now[:error] = t("flash.sessions.login.error")
      render "new"
    end
  end
  
  def destroy
    logout
    flash[:success] = t("flash.sessions.logout.success")
    redirect_to root_path
  end
  
  private
  
  def redirect_logged_in_user
    if user_logged_in?
      flash[:error] = t("flash.sessions.login.logged_in_error")
      redirect_to root_path
    end
  end
  
  def redirect_not_logged_in_user
    unless user_logged_in?
      flash[:error] = t("flash.sessions.logout.error")
      redirect_to login_path
    end
  end
end
