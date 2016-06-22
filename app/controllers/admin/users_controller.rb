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

# {"utf8"=>"✓",
#  "_method"=>"put",
#  "authenticity_token"=>"g2qikCTml6hkl9/96cASIuPUxwW644fXcWq1Ya2xLNWSfhUp1UfhiaTumhEX2RQjq8VGN1xkJV7FTRi0de5Fug==",
#  "user"=>{"email"=>"newone@test.com",
#  "firstname"=>"New",
#  "lastname"=>"One",
#  "admin"=>"0"},
#  "commit"=>"Edit User",
#  "id"=>"9"}

    if @user.update_attributes(
      email: params[:user][:email],
      firstname: params[:user][:firstname],
      lastname: params[:user][:lastname],
      admin: params[:user][:admin]
      )
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def delete
  end
end
