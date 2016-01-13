# coding: utf-8
class PushNotificationWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'default', auto_delete: true, retry_intervals: (0...25).map {|i| (i ** 4) + 15 }, body_parser: :json

  APN = Rails.env.production? ? Houston::Client.production : Houston::Client.development

  def perform(sqs_msg, body_data)
    APN.certificate = File.read(Settings.push.certification_path)
    notification = Houston::Notification.new(device: body_data["device_token"])
    notification.alert = body_data["message"]
    notification.badge = body_data["unread"].to_i
    notification.sound = "sosumi.aiff"
    notification.category = body_data["category"]
    notification.content_available = true
    notification.custom_data = body_data["custom_data"]

    APN.push(notification)
  end

end
