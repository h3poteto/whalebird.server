# == Schema Information
#
# Table name: user_settings
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  notification   :boolean          default(TRUE), not null
#  reply          :boolean          default(TRUE), not null
#  favorite       :boolean          default(TRUE), not null
#  direct_message :boolean          default(TRUE), not null
#  retweet        :boolean          default(TRUE), not null
#  device_token   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class UserSetting < ActiveRecord::Base
  after_commit :start_userstream, :if => :activate_notification?

  belongs_to :user

  validates :user_id, presence: true

  def start_userstream
    user.update_attributes!(userstream: true)
    Resque.enqueue(UserstreamWorker, user_id) unless Rails.env.test?
    # UserstreamWorker.perform_in(10.seconds, user_id) unless Rails.env.test?
  end

  def stop_userstream
    update_attributes!(notification: false)
  end

  # user.userstreamカラムはdefault: falseなので，作成された直後はuserstream?はfalseになっており，この判定によってuserstreamを起動しても問題なく動作する
  def activate_notification?
    !user.userstream?
  end
end
