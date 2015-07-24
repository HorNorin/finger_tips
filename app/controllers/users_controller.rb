class UsersController < ApplicationController
  before_action :authenticated_user!, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = <<-fin
        A confirmation email has been sent to norin@example.com.
        Please check your email address.
      fin
      redirect_to login_path
    else
      render "new"
    end
  end
  
  def edit
    @user = current_user
  end
  
  private
  
  def user_params
    params.require(:user).permit :username, :email, :password, :password_confirmation
  end
end
