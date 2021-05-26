class UsersController < ApplicationController
  before_action :must_be_logged_in, except: [:show, :new, :create, :activate]
  before_action :logged_in?, only: [:new, :create]
  before_action :current_user_admin?, only: [:index, :make_admin, :remove_admin]

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
      flash.now[:errors] = @user.errors.full_messages
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
      flash[:notice] = ["Account activated! Please log in to continue"]
      redirect_to new_session_url
    else
      redirect_to new_session_url
    end
  end

  def index
    @users = User.all.sort_by(&:id).reverse
    render :index
  end

  def make_admin
    @user = User.find_by(id: params[:id])

    if @user
      @user.toggle(:admin)
      @user.save
      flash[:notice] = ["#{@user.email} now has administrative privleges"]
      redirect_to users_url
    else
      redirect_to users_url
    end
  end

  def remove_admin
    @user = User.find_by(id: params[:id])

    if @user
      @user.toggle(:admin)
      @user.save
      flash[:notice] = ["Administrative privleges have been removed for #{@user.email}"]
      redirect_to users_url
    else
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end