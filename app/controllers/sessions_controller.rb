class SessionsController < ApplicationController
  before_action :logged_in?, except: [:destroy]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )

    if @user.nil?
      flash.now[:errors] = ["Username and Password did not match"]
      render :new
    else
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      redirect_to user_url(@user)
    end
  end

  def destroy
    if !current_user
      redirect_to new_session_url 
      return
    end

    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end
end