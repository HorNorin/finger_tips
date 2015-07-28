module SessionsHelper
  def login(user)
    session[:user_slug] = user.slug
  end
  
  def login_and_remember(user)
    cookies.permanent.signed[:user_slug] = user.slug
  end
  
  def logout
    if session[:user_slug]
      session[:user_slug] = nil
    elsif cookies.signed[:user_slug]
      cookies.delete :user_slug
    end
  end
  
  def current_user
    if session[:user_slug]
      User.friendly.find session[:user_slug] if session[:user_slug]
    elsif cookies[:user_slug]
      User.friendly.find cookies.signed[:user_slug]
    end
  end
  
  def user_logged_in?
    current_user && current_user.normal?
  end
  
  def admin_logged_in?
    current_user && current_user.admin?
  end
  
  def redirect_back_or(path)
    back = session[:back]
    session[:back] = nil
    redirect_to back || path
  end
  
  def authenticated_admin!
    flash[:error] = "Access denied!"
    redirect_to root_path
  end
  
  def authenticated_user!
    unless user_logged_in?
      flash[:error] = "You need to login before you can continue."
      redirect_to root_path
    end
  end
  
  def access_denied
    unless admin_logged_in?
      flash[:error] = "Access denied!"
      redirect_to root_url(subdomain: false)
    end
  end
end
