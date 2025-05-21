class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :two_factor_setup, :enable_two_factor]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to two_factor_setup_path, notice: 'Registration successful! Please set up two-factor authentication.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  def two_factor_setup
    generate_qr_code
  end

  def enable_two_factor
    if @user.verify_totp(params[:code])
      @user.update(two_factor_enabled: true)
      redirect_to root_path, notice: 'Two-factor authentication has been enabled.'
    else
      generate_qr_code
      flash.now[:alert] = 'Invalid code. Please try again.'
      render :two_factor_setup
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :phone, :password, :password_confirmation)
  end

  def generate_qr_code
    totp = ROTP::TOTP.new(@user.two_factor_secret)
    @qr_code = RQRCode::QRCode.new(totp.provisioning_uri(@user.email))
  end
end
