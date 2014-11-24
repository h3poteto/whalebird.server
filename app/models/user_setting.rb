class UserSetting < ActiveRecord::Base
  after_create :start_userstream
  before_update :start_userstream, :if => :activate_notification?

  belongs_to :user

  validates :user_id, presence: true

  def start_userstream
    UserstreamWorker.perform_in(10.seconds, user_id)
  end

  def activate_notification?
    if notification_changed? && notification
      return true
    else
      return false
    end
  end
end
