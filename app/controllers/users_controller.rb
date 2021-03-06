class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  def check_in
    @coffee_shop = params[:id]
    if user_signed_in?
      @user = current_user
      @user.check_in(@coffee_shop)
      redirect_to root_path
    end
  end

  private
  def user_params
    return params.require(:user).permit(:email)
  end

end
