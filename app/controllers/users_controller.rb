class UsersController < ApplicationController
  before_action :logged_in?

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in_user!(@user)
      redirect_to user_url(@user)
    else
      flash[:error] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user.email
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end