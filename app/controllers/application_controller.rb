class ApplicationController < ActionController::Base
  helper_method :current_user

  def log_in_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    redirect_to user_url(current_user) if !current_user.nil?
  end
end
