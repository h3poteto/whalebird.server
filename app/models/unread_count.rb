# == Schema Information
#
# Table name: unread_counts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  unread     :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class UnreadCount < ActiveRecord::Base
  belongs_to :user

  def decrement
    if self.unread > 0
      self.unread -= 1
      self.save!
    end
  end
end
