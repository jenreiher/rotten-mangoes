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

  def edit
  end

  def delete
  end
end
