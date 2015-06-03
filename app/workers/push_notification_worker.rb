# coding: utf-8
class PushNotificationWorker
  include Sidekiq::Worker


  APN = Rails.env.production? ? Houston::Client.production : Houston::Client.development

  def perform(device_token, alert, badge, category, custom_data)
    APN.certificate = File.read(Settings.push.certification_path)
    notification = Houston::Notification.new(device: device_token)
    notification.alert = alert
    notification.badge = badge
    notification.sound = "sosumi.aiff"
    notification.category = category
    notification.content_available = true
    notification.custom_data = custom_data

    APN.push(notification)
  end

end
