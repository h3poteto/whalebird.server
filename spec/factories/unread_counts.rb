FactoryGirl.define do
  factory :unread_count, class: :UnreadCount do
    user
    unread { [0,1].sample }
  end

end
