# coding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null, indexed
#  uid                    :string(255)      default(""), not null, indexed => [provider]
#  provider               :string(255)      default(""), not null, indexed => [uid]
#  name                   :string(255)
#  screen_name            :string(255)
#  oauth_token            :string(255)
#  oauth_token_secret     :string(255)
#  userstream             :boolean          default(FALSE), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)      indexed
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

require 'houston'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :user_setting
  has_one :unread_count

  after_create :create_unread


  def decrement_unread
    unread_count.decrement
  end

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
    else
      user.update_attributes!(
        name:     auth.info.nickname,
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
    if user_setting.device_token.present?
      custom_data = {}

      if status.present?
        case category
        when "direct_message"
          custom_data = {
            id: status.id.to_s,
            text: status.text,
            screen_name: status.sender.screen_name,
            name: status.sender.name,
            profile_image_url: status.sender.profile_image_url_https.to_s,
            created_at: status.created_at.strftime("%Y-%m-%d %H:%M")
          }
        when "reply"
          custom_data = {
            id: status.id.to_s,
            text: status.text,
            favorited: status.favorited?,
            screen_name: status.user.screen_name,
            name: status.user.name,
            protected: status.user.protected?,
            profile_image_url: status.user.profile_image_url_https.to_s,
            created_at: status.created_at.strftime("%Y-%m-%d %H:%M"),
            media: status.media.map {|m| m.media_url_https.to_s },
            video: status.media.map {|m|  m.class == Twitter::Media::AnimatedGif ? m.video_info.variants.first.url.to_s : "" }
          }
        when "retweet"
          if status.retweeted_status.present?
            custom_data = {
              id: status.retweeted_status.id.to_s,
              text: status.retweeted_status.text,
              favorited: status.favorited?,
              screen_name: status.retweeted_status.user.screen_name,
              name: status.retweeted_status.user.name,
              protected: status.retweeted_status.user.protected?,
              profile_image_url: status.retweeted_status.user.profile_image_url_https.to_s,
              created_at: status.retweeted_status.created_at.strftime("%Y-%m-%d %H:%M"),
              media: status.retweeted_status.media.map {|m| m.media_url_https.to_s },
              video: status.retweeted_status.media.map {|m| m.class == Twitter::Media::AnimatedGif ? m.video_info.variants.first.url.to_s : ""}
            }
          end
        when "favorite"
          if status.target_object.present?
            target = status.target_object
            custom_data = {
              id: target.id.to_s,
              text: target.text,
              favorited: target.favorited?,
              screen_name: target.user.screen_name,
              name: target.user.name,
              protected: target.user.protected?,
              profile_image_url: target.user.profile_image_url_https.to_s,
              created_at: target.created_at.to_datetime.strftime("%Y-%m-%d %H:%M"),
              media: target.media.map {|m| m.media_url_https.to_s},
              video: target.media.map {|m|  m.class == Twitter::Media::AnimatedGif ? m.video_info.variants.first.url.to_s : "" }
            }
          end
        end
      end

      body_data = {
        device_token: user_setting.device_token,
        message: message,
        unread: unread_count.unread.to_s,
        category: category,
        custom_data: custom_data
      }
      PushNotificationWorker.perform_async(body_data)
    end
  end

  private
  def create_unread
    self.create_unread_count
  end
end
