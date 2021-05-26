class ApplicationController < ActionController::Base
  helper_method :current_user, :current_band, :current_album

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

  def current_band
    @current_band = Band.find_by(id: params[:band_id])
  end

  def current_album
    @current_album = Album.find_by(id: params[:album_id])
  end

  def must_be_logged_in
    if current_user.nil?
      flash[:errors] = ["You must be logged in to continue"]
      redirect_to new_session_url
    end 
  end
end
