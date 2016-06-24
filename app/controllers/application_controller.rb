class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_durations

  # duration_selections gets the keys from the constant DURATION_RANGES 
  # => on the Movie class and map over it using the 
  # => movies.duration_ranges in /config/locales/en.yml

  private

  def set_durations
    @duration_selections = Movie::DURATION_RANGES.keys.map do |key|
      [I18n.t(key, scope: "movies.duration_ranges"), key]
    end
  end

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def restrict_non_admins
    unless admin?
      flash[:alert] = "You must be loggen in as an admin to access that area."
      redirect_to movies_path
    end
  end

  def admin?
    current_user && current_user.admin == true
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
  helper_method :admin?

end
