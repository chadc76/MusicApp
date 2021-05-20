class SessionsController < ApplicationController
  before_action :logged_in?, except: [:destroy]

  def new 
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )

    if user.nil?
      render user.errors.full_messages, status: :unprocessable_entity
    else
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to user_url(user)
    end
  end

  def destroy
    unless logged_in?
      redirct_to new_sessions
    end
    current_user.reset_session_token!
    session_token[:session_token] = nil
    redirect_to root_url
  end
end