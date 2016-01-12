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

FactoryGirl.define do
  factory :unread_count, class: :UnreadCount do
    user
    unread { [0,1].sample }
  end

end
