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
