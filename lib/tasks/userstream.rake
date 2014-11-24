# coding: utf-8
namespace :userstream do
  desc "boot userstream task in sidekiq"
  task :boot => :environment do
    @user_settings = UserSetting.where(notification: true)
    @user_settings.each do |user_setting|
      UserstreamWorker.perform_in(10.seconds, user_setting.user_id)
    end
  end
end
