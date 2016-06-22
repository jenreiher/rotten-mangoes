class Admin::UsersController < ApplicationController

  before_filter :restrict_non_admins

  def index
    @users = User.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def delete
  end
end
