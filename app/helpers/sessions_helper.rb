module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end
  
  def login_and_remember(user)
    cookies.permanent.signed[:user_id] = user.id
  end
  
  def logout
    if session[:user_id]
      session[:user_id] = nil
    elsif cookies.signed[:user_id]
      cookies.delete :user_id
    end
  end
  
  def current_user
    if session[:user_id]
      User.find session[:user_id] if session[:user_id]
    elsif cookies[:user_id]
      User.find cookies.signed[:user_id]
    end
  end
  
  def user_logged_in?
    !current_user.nil?
  end
  
  def authenticated_user!
    unless user_logged_in?
      flash[:error] = "You need to login before you can continue."
      redirect_to root_path
    end
  end
end
