class Admin::UsersController < ApplicationController

  before_filter :restrict_non_admins

  def index
    @users = User.all.page(params[:page]).per(5)
  end

  def show
  end

  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    UserMailer.goodbye_email(@user)
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end
end
