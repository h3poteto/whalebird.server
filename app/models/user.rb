# coding: utf-8
require 'houston'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :user_setting
  has_one :unread_count

  APN = Rails.env.production? ? Houston::Client.production : Houston::Client.development

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(
        name:     auth.info.nickname,
        provider: auth.provider,
        uid:      auth.uid,
        email:    User.create_unique_email,
        password: Devise.friendly_token[0,20],
        oauth_token: auth.credentials.token,
        oauth_token_secret: auth.credentials.secret,
        screen_name: auth.extra.access_token.params[:screen_name]
      )
    end
    user
  end

  # twitterではemailを取得できないので、適当に一意のemailを生成
  def self.create_unique_email
    User.create_unique_string + "@example.com"
  end

  def send_notification(message, category, status=nil)
    ## TODO: send remote notification
    if user_setting.device_token.present?
      APN.certificate = File.read(Settings.push.certification_path)
      notification = Houston::Notification.new(device: user_setting.device_token)
      notification.alert = message
      notification.badge = unread_count.unread
      notification.sound = "sosumi.aiff"
      notification.category = category
      notification.content_available = true

      if status.present?
        notification.custom_data = {
          id: status.id.to_s,
          text: status.text,
          screen_name: status.user.screen_name,
          name: status.user.name,
          profile_image_url: status.user.profile_image_url.to_s,
          created_at: status.created_at.in_time_zone.strftime("%m月%d日%H:%M")
        }
      end

      APN.push(notification)
    end
  end

end
