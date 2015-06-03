# coding: utf-8
class PushNotificationWorker
  include Sidekiq::Worker

  def perform(user_id, message, category, status=nil)
    user = User.find(user_id)
    user.send_notification(message, category, status)
  end

end
