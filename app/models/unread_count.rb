class UnreadCount < ActiveRecord::Base
  belongs_to :user

  def decrement
    if self.unread > 0
      self.unread -= 1
      self.save!
    end
  end
end
