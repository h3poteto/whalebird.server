class UserSetting < ActiveRecord::Base
  after_commit :start_userstream, :if => :activate_notification?

  belongs_to :user

  validates :user_id, presence: true

  def start_userstream
    user.update_attributes!(userstream: true)
    UserstreamWorker.perform_in(10.seconds, user_id) unless Rails.env.test?
  end

  def stop_userstream
    update_attributes!(notification: false)
  end

  # user.userstreamカラムはdefault: falseなので，作成された直後はuserstream?はfalseになっており，この判定によってuserstreamを起動しても問題なく動作する
  def activate_notification?
    !user.userstream?
  end
end
