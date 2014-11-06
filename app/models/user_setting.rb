class UserSetting < ActiveRecord::Base
  after_create :start_userstream

  belongs_to :user

  validates :user_id, presence: true

  def start_userstream
    UserstreamWorker.perform_async(user_id)
  end
end
