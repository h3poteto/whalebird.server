# coding: utf-8
class UserstreamWorker
  include Sidekiq::Worker
#  sidekiq_options queue: :loop

  def perform(user_id)
    user = User.find(user_id)
    TweetStream.configure do |config|
      config.consumer_key = ENV["TWITTER_CLIENT_ID"]
      config.consumer_secret = ENV["TWITTER_CLIENT_SECRET"]
      config.oauth_token = user.oauth_token
      config.oauth_token_secret = user.oauth_token_secret
      config.auth_method = :oauth
    end

    client = TweetStream::Client.new

    client.on_direct_message do |direct_message|
      @user = User.find(user_id)
      return unless @user.user_setting.notification?

      if @user.user_setting.direct_message?
        message = "DM @" + direct_message.sender.screen_name + ": " + direct_message.text
        p "sent direct message push: #{@user.screen_name}"
        @user.unread_count.unread += 1
        @user.unread_count.save!
        @user.send_notification(message, "direct_message", nil)
      end

    end

    ## for fav event
    client.on_event(:favorite) do |event|
      ## notificationによりタスク終了
      @user = User.find(user_id)
      return unless @user.user_setting.notification?

      if event[:event] == "favorite" && @user.user_setting.favorite?
        p event[:source][:screen_name]
        message = "@" + event[:source][:screen_name] + "さんがお気に入りに追加しました"
        p "sent favorite push: #{@user.screen_name}"
        @user.send_notification(message, "favorite", nil)
      end
    end

    ## read timeline
    client.userstream do |status|
      ## notificationによりタスク終了
      @user = User.find(user_id)
      return unless @user.user_setting.notification?

      if (status.text.index("RT") == 0 || status.text.index("QT") == 0) && status.user.screen_name != @user.screen_name && status.text.include?("@" + @user.screen_name)
        if @user.user_setting.retweet?
          screen_name = status.user.screen_name
          message = "@" + screen_name + "さんがRTしました"
          p "sent retweet push: #{@user.screen_name}"
          @user.send_notification(message, "retweet", nil)
        end
      elsif status.user.screen_name != @user.screen_name && status.text.include?("@" + @user.screen_name)
        if @user.user_setting.reply?
          screen_name = status.user.screen_name
          message = "@" + screen_name + ": " + status.text
          p "sent reply push: #{@user.screen_name}"
          @user.unread_count.unread += 1
          @user.unread_count.save!
          @user.send_notification(message, "reply", status)
        end
      end
    end

  end

end
