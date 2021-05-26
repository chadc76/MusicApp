class UsersController < ApplicationController
  before_action :logged_in?, except: [:show, :activate]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in_user!(@user)

      msg = UserMailer.activation_email(@user)
      msg.deliver_now
    else
      flash[:error] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    render :show
  end
  
  def activate
    @user = User.find_by( activation_token: params[:activation_token] )

    if @user && !@user.activated
      @user.toggle(:activated)
      @user.reset_token!("activation_token")
      flash[:errors] = ["Account activated! Please log in to continue"]
      redirect_to new_session_url
    else
      redirect_to new_session_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end