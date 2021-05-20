class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by_credentials(user_params[:email], user_params[:password])
    render json: @user.email
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end