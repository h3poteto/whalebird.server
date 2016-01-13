# coding: utf-8
#require 'sidekiq/api'

namespace :userstream do
  desc "boot userstream task in sidekiq"
  task :boot => :environment do

    @user_settings = UserSetting.where(notification: true)
    @user_settings.each do |user_setting|
      user_setting.user.update_attributes!(userstream: true)
      UserstreamWorker.perform_in(10.seconds, user_setting.user_id.to_s)
    end
  end

  desc "restart userstream task in sidekiq"
  task :restart => :environment do
    old_pid = "./tmp/pids/sidekiq.pid"
    if File.exists?(old_pid)
      Process.kill("KILL", File.read(old_pid).to_i)
      Sidekiq::Queue.new.clear
      Rake::Task["userstream:boot"].invoke
    end
  end

  desc "test userstream"
  task :test => :environment do

    user = User.all.first
    client = Twitter::Streaming::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CLIENT_ID"]
      config.consumer_secret = ENV["TWITTER_CLIENT_SECRET"]
      config.access_token = user.oauth_token
      config.access_token_secret = user.oauth_token_secret
    end

    client.user do |status|
      binding.pry
      case status
      when Twitter::DirectMessage
        binding.pry
        p status
      when Twitter::Streaming::Event
        binding.pry
        p status
      end
    end
  end
end
