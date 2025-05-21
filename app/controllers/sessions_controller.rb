class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      if user.two_factor_enabled
        redirect_to two_factor_path
      else
        session[:two_factor_authenticated] = true
        redirect_to root_path, notice: 'Logged in successfully!'
      end
    else
      flash.now[:alert] = 'Invalid username or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:two_factor_authenticated] = nil
    redirect_to root_path, notice: 'Logged out successfully!'
  end

  def two_factor
    return redirect_to root_path unless logged_in?
    return redirect_to root_path if session[:two_factor_authenticated]
  end

  def verify_two_factor
    if current_user.verify_two_factor_code(params[:code])
      session[:two_factor_authenticated] = true
      redirect_to root_path, notice: 'Two-factor authentication successful!'
    else
      flash.now[:alert] = 'Invalid two-factor code'
      render :two_factor
    end
  end
end
