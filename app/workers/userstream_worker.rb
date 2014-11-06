# coding: utf-8
class UserstreamWorker
  include Sidekiq::Worker
#  sidekiq_options queue: :loop

  def perform(user_id)
    @user = User.find(user_id)
    TweetStream.configure do |config|
      config.consumer_key = ENV["TWITTER_CLIENT_ID"]
      config.consumer_secret = ENV["TWITTER_CLIENT_SECRET"]
      config.oauth_token = @user.oauth_token
      config.oauth_token_secret = @user.oauth_token_secret
      config.auth_method = :oauth
    end

    client = TweetStream::Client.new

    ## for fav event
    client.on_event(:favorite) do |event|
      ## notificationによりタスク終了
      break unless @user.user_setting.notification?

      if event[:event] == "favorite" && @user.user_setting.notification? && @user.user_setting.favorite?
        screen_name = event[:srouce][:screen_name]
        message = "@" + screen_name + "さんがお気に入りに追加しました"
        ## TODO: ここでpush通知
        @user.send_notification(message, "favorite", nil)
        #send_notification(message, @user)
      end
    end

    ## read timeline
    client.userstream do |status|
      ## notificationによりタスク終了
      break unless @user.user_setting.notification?

      if (status.text.index("RT") == 0 || status.text.index("QT") == 0) && status.user.screen_name != @user.screen_name && status.text.include?("@" + @user.screen_name)
        screen_name = status.user.screen_name
        message = "@" + screen_name + "さんがRTしました"
        ## TODO: push
        p "sent retweet push"
        @user.send_notification(message, "retweet", nil) if @user.user_setting.retweet?
      elsif status.user.screen_name != @user.screen_name && status.text.include?("@" + @user.screen_name)
        screen_name = status.user.screen_name
        message = "@" + screen_name + ": " + status.text
        ## TODO: push
        p "sent reply push"
        @user.send_notification(message, "reply", status) if @user.user_setting.reply?
      end
    end

  end

end
