# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include Facebooker2::Rails::Controller
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  #  before_filter :set_facebook_session
  #  helper_method :facebook_session
  #  filter_parameter_logging :fb_sig_friends

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def admin_required
    unless current_user
      store_location
      unless session[:return_to] == "/"
        flash[:alert] = "You must be logged in to access this page"
      end
      redirect_to login_path
      return false
    end

    unless current_user.has_role?("Admin")
      flash[:alert] = "You don't have permission to access this page."
      redirect_to root_path
    end
  end

  def require_user
    logger.debug "ApplicationController::require_user"
    unless current_user
      store_location
      flash[:alert] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    logger.debug "ApplicationController::require_no_user"
    if current_user
      store_location
      flash[:alert] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri unless request.xhr?
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
