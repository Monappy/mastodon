# frozen_string_literal: true

class User < ApplicationRecord
  include Settings::Extend

  devise :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :two_factor_authenticatable, :two_factor_backupable, :omniauthable,
         otp_secret_encryption_key: ENV['OTP_SECRET'],
         otp_number_of_backup_codes: 10

  belongs_to :account, inverse_of: :user, required: true
  accepts_nested_attributes_for :account

  validates :locale, inclusion: I18n.available_locales.map(&:to_s), unless: 'locale.nil?'
  validates :email, email: true

  scope :recent,    -> { order('id desc') }
  scope :admins,    -> { where(admin: true) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def confirmed?
    confirmed_at.present?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def setting_default_privacy
    settings.default_privacy || (account.locked? ? 'private' : 'public')
  end

  def setting_boost_modal
    settings.boost_modal
  end

  def setting_auto_play_gif
    settings.auto_play_gif
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def self.login_with_monappy(data)
    temp_user = User.find_by(email: data.info[:mail])
    if temp_user.present? and not temp_user.monappy_uid.present?
      temp_user.monappy_uid = data.info[:id]
      temp_user.save!
    end

    user = User.find_or_create_by(
        monappy_uid: "#{data.info[:id]}"
    )
    unless user.account.present?
      p "But not presented..."
      user.account = Account.new(username: data.info[:nickname])
      user.email = data.info[:mail]
      user.password  = Devise.friendly_token[0,20]
      user.account.avatar_remote_url = data.info[:image]
      begin 
        user.save!
      rescue
        Rails.logger.warn("Can't save user!")
      end
      user.skip_confirmation!
    end
    user
  end
end
