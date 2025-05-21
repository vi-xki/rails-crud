class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      # flash[:alert] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def require_two_factor
    if logged_in? && current_user.two_factor_enabled && !session[:two_factor_authenticated]
      redirect_to two_factor_path
    end
  end
end
