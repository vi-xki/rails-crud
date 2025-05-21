class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: { with: /\A\+?\d{10,15}\z/ }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  before_validation :generate_two_factor_secret, on: :create

  def verify_totp(code)
    totp = ROTP::TOTP.new(two_factor_secret)
    totp.verify(code)
  end

  def two_factor_qr_code
    totp = ROTP::TOTP.new(two_factor_secret, issuer: "YourApp")
    RQRCode::QRCode.new(totp.provisioning_uri(email))
  end

  def verify_two_factor_code(code)
    return false unless two_factor_enabled
    totp = ROTP::TOTP.new(two_factor_secret)
    totp.verify(code)
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def generate_two_factor_secret
    self.two_factor_secret = ROTP::Base32.random
    self.two_factor_enabled = false
  end
end
