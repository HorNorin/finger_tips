class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_locale
  before_action :redirect_to_admin
  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
  
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
  
  include SessionsHelper
  
  protected
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def extract_locale_from_tld
    parsed_locale = request.host.split(".")
  end

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end
    
  private
  
  def redirect_to_admin
    if admin_logged_in? && request.subdomain != "admin"
      redirect_to admin_root_url(subdomain: :admin)
    end
  end
end
