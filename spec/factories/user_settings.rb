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

FactoryGirl.define do
  factory :user_setting, class: :UserSetting do
    user
    device_token { Faker::Lorem.characters(100) }

    factory :user_setting_notification_off do
      notification false
    end

    factory :user_setting_notification_on do
      notification true
    end
  end

end
