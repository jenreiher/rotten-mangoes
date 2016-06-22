class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if admin?
        redirect_to admin_users_path
      else
        session[:user_id] = @user.id #auto log in
        redirect_to movies_path, notice: "Welcome back, #{@user.firstname}!"
      end
    else
      render :new
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

end
